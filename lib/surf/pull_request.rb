# frozen_string_literal: true

require 'surf/utils/mappingable'
require 'surf/registry'

module Surf
  class PullRequest
    extend Configurable
    include Mappingable

    cattr_accessor(:content_provider) { Surf::Registry.content_provider }

    attr_reader :repository, :id

    def initialize(repository, id)
      @repository = repository
      @id = id
      retreive_info
    end

    private

    def retreive_info
      body = self.class.content_provider.new.pull_request(repository, id)
      create_mapping(body)
    end
  end
end
