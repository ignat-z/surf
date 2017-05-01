# frozen_string_literal: true

require 'surf/registry'

module Surf
  class PullRequestLogger
    extend Configurable

    cattr_accessor(:pull_request_webhook_class) { Surf::Registry.pull_request_webhook_class }

    def initialize(context)
      @context = context
    end

    def call
      webhook = self.class.pull_request_webhook_class.new(context.raw_body)
      Surf.logger.info(pull_request_info(webhook))
    end

    private

    attr_reader :context

    def pull_request_info(webhook)
      "#{webhook.repository.full_name}##{webhook.pull_request.number}" \
        " was #{webhook.action} by #{webhook.sender_login}" \
        ", current state: #{webhook.pull_request.state}"
    end
  end
end
