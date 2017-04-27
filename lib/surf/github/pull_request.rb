# frozen_string_literal: true

require 'forwardable'
require 'surf/pull_request'

module Surf
  module Github
    class PullRequest < Surf::PullRequest
      extend Forwardable

      def_delegators :info, :number, :state, :title

      private

      attr_reader :info

      def retreive_info
        @info ||= self.class.content_provider.new.pull_request(repository, id)
      end
    end
  end
end
