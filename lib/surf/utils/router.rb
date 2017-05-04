# frozen_string_literal: true

require 'rack'
require 'omniauth'
require 'omniauth-github'

require 'surf/utils/route_matcher'

module Surf
  class Router
    include RouteMatcher
    extend Configurable
    DEFAULT_RESPONSE = ->(_env) { [404, { 'Content-Type' => 'text/plain' }, ['Not found']] }

    cattr_accessor(:default_routes) { [] }
    def initialize(routes = self.class.default_routes)
      @routes = routes
    end

    def call(env)
      @routes.each do |route|
        method, pattern = route.route
        match = env['REQUEST_METHOD'] == method && regex_matcher(env['PATH_INFO'], pattern)
        next unless match
        return run_rack(route, env)
      end
      run_rack(DEFAULT_RESPONSE, env)
    end

    private

    def run_rack(callable, env)
      Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::Session::Cookie, key: '_surf_session', secret: ENV['COOKIE_SECRET']
        use OmniAuth::Builder do
          provider :github,
                   ENV['OAUTH_KEY'], ENV['OAUTH_SECRET'], callback_url: ENV['OAUTH_CALLBACK']
        end
        run callable
      end.to_app.call(env)
    end
  end
end
