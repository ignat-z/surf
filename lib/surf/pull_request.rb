# frozen_string_literal: true

require 'surf/configuration'

module Surf
  class PullRequest
    extend Configuration
    include Mappingable

    cattr_accessor :content_provider

    def initialize(repository, id)
      @repository = repository
      @id = id
      body = self.class.content_provider.pull_request_info(repository, id)
      create_mapping(body)
    end

    private

    attr_reader :repository, :id
  end
end
