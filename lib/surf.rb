# frozen_string_literal: true

require 'forwardable'
require 'puma'
require 'redis'

require 'surf/utils/configurable'
require 'surf/utils/translation'
require 'surf/utils/router'

require 'surf/configuration'
require 'surf/webhook_handler'
require 'surf/version'

module Surf
  class << self
    extend Forwardable
    extend Translation

    def_delegators :configuration, *Configuration.attributes.map(&:name)

    def run
      app = Surf::Router.new([Surf::WebhookHandler])
      @server_thread = Thread.new { run_app(app) }
      @server_thread.abort_on_exception = true
    end

    def run_app(app)
      @server = Puma::Server.new(app)
      begin
        @server.add_tcp_listener(Surf.host, Surf.port)
      rescue Errno::EADDRINUSE, Errno::EACCES => exception
        handle_error(exception)
      end
      @server.run
    end

    def handle_error(exception)
      Surf.logger.fatal(exception)
      abort
    end

    def redis
      @redis ||= Redis.new(redis_url: Surf.redis_url)
    end

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Surf::Configuration.new
    end
  end
  private_class_method :configuration
end
