# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module Surf
  class GithubRequest
    def initialize(token: ENV.fetch('GITHUB_TOKEN'), http_lib: Net::HTTP)
      @token = token
      @http_lib = http_lib
    end

    def post(url, message)
      request(url) do |uri|
        Net::HTTP::Post.new(uri.path).tap do |request|
          request.body = { 'body' => message }.to_json
        end
      end
    end

    def get(url, params={})
      request(url) do |uri|
        uri.query = URI.encode_www_form(params)
        Net::HTTP::Get.new(uri)
      end
    end

    private

    attr_reader :token, :http_lib

    def request(url)
      return if url.nil?
      uri = URI.parse(url)
      http = http_lib.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = yield(uri)
      request.add_field('Accept', "application/vnd.github.black-cat-preview+json")
      request.add_field('Authorization', "token #{token}")
      parse_response(http.request(request))
    end

    def parse_response(response)
      return JSON.parse(response.body) if (200..299).cover?(response.code.to_i)
      raise "Can't parse response body, code: #{response.code}"
    end
  end
end
