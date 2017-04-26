# frozen_string_literal: true

require 'surf/utils/configurable'
require 'surf/storages/webhook_storage'
require 'surf/registry'

module Surf
  class PingWebhookSaver
    extend Configurable

    cattr_accessor :repository_class, Lazy.new(-> { Surf::Registry.repository_class })
    cattr_accessor :storage, Surf::WebhookStorage.new

    def initialize(context)
      @context = context
    end

    def call
      repository = self.class.repository_class.new(context.raw_body)
      self.class.storage.save(id: repository.id, value: context.raw_body)
    end

    private

    attr_reader :context
  end
end
