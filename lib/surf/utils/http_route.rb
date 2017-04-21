# frozen_string_literal: true

require 'rack/request'

module Surf
  class HttpRoute
    extend Configuration

    def self.mapping
      raise 'Please, provide tuple where first value is method and second value' \
            "is path.\nExample: ['GET', '/route1/:id']\nFrom: `#{name}.mapping`."
    end

    def self.call(env, match)
      request = Rack::Request.new(env)
      response = Rack::Response.new
      new(request, match, response).call
    end

    attr_reader :match, :request, :response

    def initialize(request, match, response)
      @request = request
      @match = match
      @response = response
    end

    def call
      raise
    end
  end
end
