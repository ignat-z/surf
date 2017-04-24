# frozen_string_literal: true

require 'surf/utils/configurationable'
require 'rack/request'

module Surf
  class HttpRoute
    extend Configurationable

    def self.route
      raise 'Please, provide tuple where first value is method and second value' \
            "is path.\nExample: ['GET', '/route1/:id']\nFrom: `#{name}.route`."
    end

    attr_reader :match, :request, :response

    def initialize(env, match = {})
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @match = match
    end

    def call
      raise
    end
  end
end
