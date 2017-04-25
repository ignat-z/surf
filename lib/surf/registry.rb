# frozen_string_literal: true

require 'surf/utils/configurationable'

module Surf
  class Registry
    extend Configurationable

    cattr_accessor :pull_request_class
    cattr_accessor :repositroy_class
    cattr_accessor :content_provider
    cattr_accessor :webhook_default_callback_class
  end
end
