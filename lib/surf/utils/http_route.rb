# frozen_string_literal: true

require 'rack/request'

module Surf
  class HttpRoute
    extend Configurable

    def self.route
      raise(I18n.t('surf.routes.no_mapping') % name)
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
