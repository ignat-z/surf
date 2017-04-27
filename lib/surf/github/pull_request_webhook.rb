# frozen_string_literal: true

require 'surf/pull_request_webhook'

module Surf
  module Github
    class PullRequestWebhook < Surf::PullRequestWebhook
      cattr_accessor(:mapping, action:        %w[action],
                               number:        %w[number],
                               repository_id: %w[repository id],
                               sender_login:  %w[sender login],
                               id:            %w[pull_request id])

      def repository
        @repository ||= self.class.repository_class.find(repository_id)
      end

      def pull_request
        @pull_request ||= repository.pull_request(number)
      end
    end
  end
end
