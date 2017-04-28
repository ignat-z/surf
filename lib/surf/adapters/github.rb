# frozen_string_literal: true

require 'surf/github/content_provider'
require 'surf/github/pull_request_webhook'
require 'surf/github/pull_request'
require 'surf/github/repository'

require 'surf/registry'

module Surf
  module Adapters
    class Github
      def build!
        Surf::Registry.tap do |config|
          config.pull_request_webhook_class =  Surf::Github::PullRequestWebhook
          config.pull_request_class         =  Surf::Github::PullRequest
          config.repository_class           =  Surf::Github::Repository
          config.content_provider           =  Surf::Github::ContentProvider
        end
      end
    end
  end
end
