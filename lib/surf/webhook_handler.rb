# frozen_string_literal: true

require 'openssl'
require 'rack/utils'
require 'rack/request'

require 'surf/callbacks/default_callback'
require 'surf/callbacks/ping_webhook_saver'
require 'surf/callbacks/pull_request_change_logger'
require 'surf/callbacks/open_pull_request_notifier'

require 'surf/registry'

require 'surf/utils/mappingable'
require 'surf/utils/http_route'

module Surf
  class WebhookHandler < HttpRoute
    include Mappingable
    DEFAULT_ACTION   = 'default'
    KEY_GENERATOR    = ->(event, action) { [event, action].join('+') }

    cattr_accessor(:default_callback, Surf::DefaultCallback)
    cattr_accessor(:mapping, action: %w[action])
    cattr_accessor(:callbacks, {})
    cattr_accessor(:route, %w[POST /webhook])
    cattr_accessor(:secret) { ENV['GITHUB_SECRET_TOKEN'] }

    attr_reader :raw_body

    def self.add_callback(event:, action: DEFAULT_ACTION, callback:)
      key = KEY_GENERATOR.call(event, action)
      callbacks[key] ||= [default_callback]
      callbacks[key].unshift(callback)
    end

    def call
      parse_body
      return invalid_sender_response unless valid_sender?
      fetch_callbacks.map { |callback| callback.new(self).call }.last
    end

    private

    def fetch_callbacks
      self.class.callbacks.fetch(action_key) do
        Surf.logger.warn(I18n.t('surf.webhooks.no_callback') % action_key)
        [self.class.default_callback]
      end
    end

    def action_key
      KEY_GENERATOR.call(request.env['HTTP_X_GITHUB_EVENT'], action || DEFAULT_ACTION)
    end

    def invalid_sender_response
      Surf.logger.error(I18n.t('surf.webhooks.error_signature'))
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
