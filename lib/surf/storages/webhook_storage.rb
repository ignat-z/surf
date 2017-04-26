# frozen_string_literal: true

require 'surf/registry'
require 'surf/utils/configurable'
require 'surf/utils/string_utils'

module Surf
  class WebhookStorage
    extend Configurable
    include StringUtils

    cattr_accessor :redis, (Lazy.new { Registry.redis })

    def save(id:, value:)
      self.class.redis.hset(storage_key, id, value)
    end

    def find(id:)
      self.class.redis.hget(storage_key, id)
    end

    def all
      self.class.redis.hgetall(storage_key).map { |_, value| value }
    end

    private

    def storage_key
      underscore(demodulize(self.class.to_s))
    end
  end
end
