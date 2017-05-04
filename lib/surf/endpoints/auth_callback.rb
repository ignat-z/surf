# frozen_string_literal: true

module Surf
  class AuthCallback < HttpRoute
    cattr_accessor(:route, %w[GET auth/:provider/callback])

    def call
      request.session[:user] = request.env['omniauth.auth'] if request.env['omniauth.auth']
      redirect('/home')
    end
  end
end
