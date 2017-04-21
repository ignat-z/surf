# frozen_string_literal: true

require 'surf/repository'
require 'surf/utils/mappingable'

module Surf
  module Github
    class PullRequest < Surf::PullRequest
      cattr_accessor :content_provider, Surf::Github::ContentProvider
    end
  end
end