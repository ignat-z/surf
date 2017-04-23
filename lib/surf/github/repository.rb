# frozen_string_literal: true

require 'surf/github/pull_request'
require 'surf/repository'

module Surf
  module Github
    class Repository < Surf::Repository
      cattr_accessor :mapping, full_name:     %w[repository full_name],
                               id:            %w[repository id]
      cattr_accessor :pull_request_class, Surf::Github::PullRequest
    end
  end
end
