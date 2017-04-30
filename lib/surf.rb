# frozen_string_literal: true

require 'i18n'
require 'forwardable'
require 'puma'
require 'redis'

require 'surf/utils/router'
require 'surf/configuration'
require 'surf/webhook_handler'
require 'surf/version'

module Surf
  extend SingleForwardable
  def_delegators :configuration, *Configuration.attributes.map(&:name)

  class << self
    def run
      load_locales
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

    def load_locales
      I18n.load_path = Dir['./config/locales/*.{rb,yml}']
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
