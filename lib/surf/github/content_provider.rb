# frozen_string_literal: true

require 'octokit'
require 'surf/utils/configurable'
require 'surf/content_provider'

module Surf
  module Github
    class ContentProvider < Surf::ContentProvider
      extend Configurable

      cattr_accessor :client, Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

      def pull_request(repository, id)
        self.class.client.pull_request(repository.full_name, id)
      end
    end
  end
end
