# frozen_string_literal: true

require 'surf/utils/configurable'

module Surf
  class Registry
    extend Configurable

    cattr_accessor(:pull_request_class)
    cattr_accessor(:repository_class)
    cattr_accessor(:content_provider)
    cattr_accessor(:webhook_default_callback_class)
    cattr_accessor(:redis)
  end
end
