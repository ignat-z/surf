# frozen_string_literal: true

require 'octokit'

module Surf
  class IssueMessenger
    extend Configurable
    STRATEGIES = %i[add_new replace_last add_to_first].freeze

    cattr_accessor(:client) { Octokit::Client.new(access_token: ENV['GITHUB_TOKEN']) }

    def initialize(repo, issue_id)
      @repo = repo
      @issue_id = issue_id
    end

    def comment(text, strategy: STRATEGIES.first)
      raise 'Unknown messaging strategy' unless STRATEGIES.include?(strategy)
      method(strategy).call(text)
    end

    private

    def add_new(text)
      self.class.client.add_comment(repo.full_name, issue_id, text)
    end

    def replace_last(text)
      original_comment = find_last_user_comment
      return add_new(text) unless original_comment
      self.class.client.update_comment(repo.full_name, original_comment.id, text)
    end

    def add_to_first(text)
      original_body = self.class.client.issue(repo.full_name, issue_id).body
      new_body = [original_body, "\n", text].join
      self.class.client.update_issue(repo.full_name, issue_id, body: new_body)
    end

    def find_last_user_comment
      @login ||= self.class.client.login
      self.class
          .client.issue_comments(repo.full_name, issue_id)
          .reverse.find { |issue| issue.user.login == @login }
    end

    attr_reader :repo, :issue_id
  end
end
