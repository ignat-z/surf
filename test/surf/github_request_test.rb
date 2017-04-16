# frozen_string_literal: true

require 'test_helper'
require 'surf/github_request'

module Fake
  class SuccessResponse
    def code
      '200'
    end

    def body
      '{"a":1,"b":2}'
    end
  end

  class FailResponse
    def code
      '500'
    end
  end

  class Http
    attr_accessor :use_ssl, :verify_mode, :host, :port
    def initialize(host, port)
      @host = host
      @port = port
    end

    def request(_request)
      host == 'success.com' ? Fake::SuccessResponse.new : Fake::FailResponse.new
    end
  end
end

describe Surf::GithubRequest do
  subject { Surf::GithubRequest.new(token: github_token, http_lib: http_lib) }

  let(:github_token) { 'GITHUB_TOKEN' }
  let(:http_lib) { Fake::Http }

  context '#get' do
    it 'make & parse GET request for github with headers' do
      result = subject.get('http://success.com/iddqd?param1=value')
      assert_equal result, 'a' => 1, 'b' => 2
    end

    it 'make & raise error in case of GET request fails' do
      assert_raises RuntimeError do
        subject.get('http://failure.com/iddqd?param1=value')
      end
    end
  end

  context '#parse' do
    it 'make & parse POST request for github with headers' do
      result = subject.post('http://success.com/iddqd?param1=value', [1, 2, 3])
      assert_equal result, 'a' => 1, 'b' => 2
    end

    it 'make & raise error in case of GET request fails' do
      assert_raises RuntimeError do
        subject.post('http://failure.com/iddqd?param1=value', [1, 2, 3])
      end
    end
  end
end
