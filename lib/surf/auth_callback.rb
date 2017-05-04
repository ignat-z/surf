# frozen_string_literal: true

module Surf
  class AuthCallback < HttpRoute
    cattr_accessor(:route, %w[GET auth/:provider/callback])

    def call
      request.session[:user] = request.env['omniauth.auth'] if request.env['omniauth.auth']
      response.redirect('/home')
      response
    end
  end
end
