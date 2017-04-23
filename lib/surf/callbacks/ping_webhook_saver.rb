# frozen_string_literal: true

require 'surf/utils/configuration'
require 'surf/github/repository'

module Surf
  class PingWebhookSaver
    extend Configuration

    cattr_accessor :storage

    def initialize(context)
      @context = context
    end

    def call
      repository = Surf::Github::Repository.new(context.raw_body)
      self.class.storage.save(id: repository.id, value: context.raw_body)
    end

    private

    attr_reader :context
  end
end
