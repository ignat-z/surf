# frozen_string_literal: true

require 'surf/registry'
require 'surf/storages/pair_pr_storage'

module Surf
  class PrPair < PullRequestLogger
    cattr_accessor(:client) { Octokit::Client.new(access_token: ENV['GITHUB_TOKEN']) }

    def call
      exist = Surf::PairPrStorage.new.find(id: webhook.pull_request.number)
      status = exist ? 'failure' : 'success'
      self.class.client.create_status(webhook.repository.full_name, webhook.pull_request.head.sha, status, {context: 'pair ci check'})
    end
  end
end
