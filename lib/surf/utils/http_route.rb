# frozen_string_literal: true

require 'rack/request'
require 'surf/utils/route_matcher'

module Surf
  class HttpRoute
    include RouteMatcher
    extend Configurable

    def self.route
      raise(I18n.t('surf.routes.no_mapping') % name)
    end

    attr_reader :match, :request, :response

    def self.call(env)
      new(env).call
    end

    def initialize(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @match = regex_matcher(env['PATH_INFO'], self.class.route.last)
    end

    def call
      raise
    end
  end
end
