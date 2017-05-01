# frozen_string_literal: true

require 'logger'

module Surf
  class Configuration
    extend Configurable
    ConfigurationParameter = Struct.new(:name, :default, :caster)
    DEFAULT_CASTER = ->(value) { value }

    def self.config(name, default: nil, caster: DEFAULT_CASTER)
      ConfigurationParameter.new(name, default, caster)
    end
    private_class_method :config

    def self.default_logger
      @default_logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = 'Surf'
      end
    end

    cattr_accessor(
      :attributes,
      [
        config(:host, default: 'localhost'),
        config(:port, default: 9001),
        config(:redis_url, default: 'redis://127.0.0.1:6379/1'),
        config(:logger, default: default_logger)
      ]
    )
    attr_accessor(*attributes.map(&:name))

    def initialize
      self.class.attributes.each do |attribute|
        send("#{attribute.name}=", attribute.caster.call(attribute.default))
      end
    end
  end
end
