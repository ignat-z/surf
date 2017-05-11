# frozen_string_literal: true

require 'surf/registry'
require 'surf/storages/pair_pr_storage'

module Surf
  class PairPr < PullRequestLogger
    cattr_accessor(:client) { Octokit::Client.new(access_token: ENV['GITHUB_TOKEN']) }

    def call
      self.class.client.create_status(webhook.repository.full_name,
        webhook.pull_request.head.sha, status, {context: 'surf/pair-pr'})
    end

    def status
      exist = Surf::PairPrStorage.new.find(id: webhook.pull_request.uniq_id)
      exist ? 'failure' : 'success'
    end
  end
end
