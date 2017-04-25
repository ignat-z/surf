# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/http_route'
require 'surf/utils/router'
require 'rack/test'

describe Surf::Router do
  include Rack::Test::Methods

  let(:app) { Surf::Router.new([FakeStore::SimpleRoute, FakeStore::ComplexRouteWithMathcing]) }

  context 'when there is no any routing' do
    it 'return 404 code' do
      post '/'
      assert_equal 404, last_response.status
    end
  end

  context 'when has mappingable routes' do
    it 'return 200 code if can find matching route' do
      get '/test1'
      assert last_response.ok?
    end

    it 'return 200 code if can find matching route' do
      get '/test2/23/pattern/oleg'
      assert last_response.ok?
      assert_equal last_response.body, '23oleg'
    end

    it 'return 404 code if matching is not completed' do
      get '/test2/23/42/pattern/oleg'
      assert_equal 404, last_response.status
    end
  end
end
