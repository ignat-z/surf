# frozen_string_literal: true

require 'rack'
require 'surf/utils/configurable'

module Surf
  class Router
    extend Configurable

    cattr_accessor(:default_routes) { [] }
    def initialize(routes = self.class.default_routes)
      @routes = routes
    end

    def default
      [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
    end

    def call(env)
      @routes.each do |route|
        method, pattern = route.route
        match = env['REQUEST_METHOD'] == method && regex_matcher(env['PATH_INFO'], pattern)
        return route.new(env, match).call if match
      end
      default
    end

    private

    def regex_matcher(path, pattern)
      parsed_pattern = pattern.split('/').map do |part|
        part =~ /\A:.+/ ? "(?<#{part.delete(':')}>[^\/]*)" : part
      end.join('/')
      path.match(Regexp.new(parsed_pattern))
    end
  end
end
