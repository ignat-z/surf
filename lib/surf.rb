# frozen_string_literal: true

require 'puma'

require 'surf/utils/router'
require 'surf/webhook_handler'
require 'surf/version'

module Surf
  def self.run
    conifg = OpenStruct.new(host: 'localhost', port: 9001)
    app = Surf::Router.new([Surf::WebhookHandler])
    @server_thread = Thread.new { run_app(app, conifg) }
    @server_thread.abort_on_exception = true
  end

  def self.run_app(app, conifg)
    @server = Puma::Server.new(app)
    begin
      @server.add_tcp_listener(conifg.host, conifg.port)
    rescue Errno::EADDRINUSE, Errno::EACCES => exception
      handle_error(exception)
    end
    @server.run
  end

  def self.handle_error(exception)
    p exception
    abort
  end
end
