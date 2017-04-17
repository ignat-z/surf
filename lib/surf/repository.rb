# frozen_string_literal: true

require 'surf/configuration'

module Surf
  class Repository
    extend Configuration

    cattr_accessor :mapping, {}

    def initialize(webhook_body)
      @webhook_body = JSON.parse(webhook_body)
      self.class.mapping.each do |method_name, hash_path|
        define_singleton_method(method_name) do
          @webhook_body.dig(*hash_path)
        end
      end
    end

    private

    attr_reader :webhook_body
  end
end
