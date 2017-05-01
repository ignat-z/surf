# frozen_string_literal: true

module Surf
  class Registry
    extend Configurable

    cattr_accessor(:pull_request_class)
    cattr_accessor(:pull_request_webhook_class)
    cattr_accessor(:repository_class)
    cattr_accessor(:content_provider)
  end
end
