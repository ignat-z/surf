# frozen_string_literal: true

require 'json'
require 'rack'
require 'surf/utils/http_route'
require 'erb'

module Surf
  class HomePage < HttpRoute
    include ERB::Util

    cattr_accessor(:route, %w[GET /home])
    cattr_accessor(:template) { File.read('./views/home_page.html.erb') }

    def call
      return redirect('/auth/github') unless authenticated?
      response.body = [ERB.new(self.class.template).result(binding)]
      response[Rack::CONTENT_TYPE] = 'text/html; charset=UTF-8'
      response
    end
  end
end
