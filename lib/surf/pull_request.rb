# frozen_string_literal: true

require 'surf/utils/mappingable'
require 'surf/utils/configurationable'

module Surf
  class PullRequest
    extend Configurationable
    include Mappingable

    cattr_accessor :content_provider

    def initialize(repository, id)
      @repository = repository
      @id = id
      body = self.class.content_provider.new.pull_request(repository, id)
      create_mapping(body)
    end

    private

    attr_reader :repository, :id
  end
end
