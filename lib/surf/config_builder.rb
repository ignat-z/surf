# frozen_string_literal: true

require 'ostruct'
require 'yaml'

require 'surf/utils/string_utils'

require 'surf/adapters/github'

module Surf
  class ConfigBuilder
    extend Configurable
    include StringUtils

    cattr_accessor(:application) { Surf }
    cattr_accessor(:webhook_handler) { Surf::WebhookHandler }
    cattr_accessor(:router) { Surf::Router }

    def initialize(content)
      @parsed_body = YAML.safe_load(content).fetch('surf')
    end

    def build!
      configure_adapter
      configure_applicaiton
      configure_endpoints
      configure_callbacks
    end

    private

    def configure_applicaiton
      self.class.application.configure do |config|
        fetch_key('application').each do |key, value|
          config.send("#{key}=", value)
        end
      end
    end

    def configure_adapter
      adapter_class = fetch_key('adapter') { raise 'Unknown adapter' }
      cast_string_to_class(adapter_class).new.build!
    end

    def configure_endpoints
      endpoints = fetch_key('endpoints').map { |classname| cast_string_to_class(classname) }
      self.class.router.default_routes = endpoints
    end

    def configure_callbacks
      callbacks = fetch_key('webhook_callbacks').flat_map { |info| process_callback_info(info) }
      callbacks.each { |callback| self.class.webhook_handler.add_callback(callback) }
    end

    def fetch_key(name)
      @parsed_body.fetch(name)
    end

    def process_callback_info(event_description)
      event_description.fetch('callbacks').map do |callback|
        {}.tap do |record|
          record[:event] = event_description.fetch('event')
          record[:action] = event_description['action'] if event_description['action']
          record[:callback] = cast_string_to_class(callback)
        end
      end
    end

    def cast_string_to_class(string)
      Object.const_get(camelize(string))
    end
  end
end
