# frozen_string_literal: true

require 'surf/utils/mappingable'
require 'surf/registry'

module Surf
  class PullRequestWebhook
    include Mappingable
    cattr_accessor(:repository_class) { Surf::Registry.repository_class }

    def initialize(webhook_body)
      @webhook_body = JSON.parse(webhook_body)
      create_mapping(@webhook_body)
    end
  end
end
