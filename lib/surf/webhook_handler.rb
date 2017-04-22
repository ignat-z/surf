# frozen_string_literal: true

require 'rack/utils'
require 'rack/request'

module Surf
  class DefaultCallback
    def initialize(context)
      @context = context
    end

    def call
      context.response
    end

    private

    attr_reader :context
  end

  class WebhookHandler < HttpRoute
    include Mappingable
    DEFAULT_ACTION = 'default'
    KEY_GENERATOR = ->(event, action) { [event, action].join('+') }
    cattr_accessor :default_callback, DefaultCallback
    cattr_accessor :mapping, action: %w[action]
    cattr_accessor :callbacks, {}
    cattr_accessor :route, %w[POST /webhook]
    cattr_accessor :secret, ENV['GITHUB_SECRET_TOKEN']

    def self.add_callback(event:, action: DEFAULT_ACTION, callback:)
      key = KEY_GENERATOR.call(event, action)
      callbacks[key] ||= [default_callback]
      callbacks[key].unshift(callback)
    end

    def call
      parse_body
      return invalid_sender_response unless valid_sender?
      self.class.callbacks.fetch(action_key, [self.class.default_callback]).map do |callback|
        callback.new(self).call
      end.last
    end

    private

    attr_reader :raw_body

    def action_key
      KEY_GENERATOR.call(request.env['HTTP_X_GITHUB_EVENT'], action || DEFAULT_ACTION)
    end

    def invalid_sender_response
      response.tap do |r|
        r.status = 500
        r.body = 'Invalid sender'
      end
    end

    def valid_sender?
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'), self.class.secret, raw_body
      )
      Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
    end

    def parse_body
      @raw_body = request.body.read
      @body = JSON.parse(@raw_body)
      create_mapping(@body)
    end
  end
end
