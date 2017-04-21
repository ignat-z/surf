# frozen_string_literal: true

require 'surf/repository'
require 'surf/mappingable'

module Surf
  module Github
    class Repository < Surf::Repository
      cattr_accessor :mapping, full_name: %w[repository full_name]
      cattr_accessor :pull_request_class, Surf::Github::PullRequest
    end
  end
end
