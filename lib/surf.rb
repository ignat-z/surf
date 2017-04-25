# frozen_string_literal: true

require 'forwardable'
require 'puma'

require 'surf/utils/router'
require 'surf/configuration'
require 'surf/webhook_handler'
require 'surf/version'

module Surf
  extend SingleForwardable
  def_delegators :configuration, :check_configuration!, *Configuration.attributes.map(&:name)

  def self.run
    app = Surf::Router.new([Surf::WebhookHandler])
    @server_thread = Thread.new { run_app(app) }
    @server_thread.abort_on_exception = true
  end

  def self.run_app(app)
    @server = Puma::Server.new(app)
    begin
      @server.add_tcp_listener(Surf.host, Surf.port)
    rescue Errno::EADDRINUSE, Errno::EACCES => exception
      handle_error(exception)
    end
    @server.run
  end

  def self.handle_error(exception)
    Surf.logger.fatal(exception)
    abort
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Surf::Configuration.new
  end
  private_class_method :configuration
end
