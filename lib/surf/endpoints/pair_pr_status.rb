# frozen_string_literal: true

require 'json'
require 'rack'
require 'surf/utils/http_route'
require 'erb'

module Surf
  class PairPrStatus < HttpRoute
    cattr_accessor(:route, %w[GET /pair-pr/:user/:repo/:id])
    cattr_accessor(:template) { File.read('./views/pair_pr.html.erb') }
    cattr_accessor(:client) { Octokit::Client.new(access_token: ENV['GITHUB_TOKEN']) }

    def call
      response.body = [ERB.new(self.class.template).result(binding)]
      response[Rack::CONTENT_TYPE] = 'text/html; charset=UTF-8'
      response
    end

    private

    def pull_requests
      x = self.class.client.search_issues("is:pr state:open user:ignat-zakrevsky").items
      x.map { |i| [i.repository_url.split("/").last(2).join('/'), i.number].join("#") }
    end

    def uniq_id
      [match[:user], '/', match[:repo], '#', match[:id]].join
    end

    def pair
      Surf::PairPrStorage.new.find(id: uniq_id)
    end
  end
end
