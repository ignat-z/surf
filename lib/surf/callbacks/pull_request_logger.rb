# frozen_string_literal: true

require 'surf/registry'

module Surf
  class PullRequestLogger
    extend Configurable

    cattr_accessor(:pull_request_webhook_class) { Surf::Registry.pull_request_webhook_class }

    def initialize(context)
      @context = context
      @webhook = find_webhook
    end

    def call
      Surf.logger.info(pull_request_info)
    end

    private

    attr_reader :context, :webhook

    def find_webhook
      self.class.pull_request_webhook_class.new(context.raw_body)
    end

    def pull_request_info
      "#{webhook.repository.full_name}##{webhook.pull_request.number}" \
        " was #{webhook.action} by #{webhook.sender_login}" \
        ", current state: #{webhook.pull_request.state}"
    end
  end
end
