# frozen_string_literal: true

require 'json'
require 'surf/mappingable'

module Surf
  class Repository
    include Mappingable

    def initialize(webhook_body)
      @webhook_body = JSON.parse(webhook_body)
      create_mapping(@webhook_body)
    end

    def pull_request_url(_id)
      raise
    end

    attr_reader :webhook_body
  end
end
