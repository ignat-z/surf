# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/http_route'
require 'surf/utils/router'
require 'rack/test'

module Fake
  class SimpleRoute < Surf::HttpRoute
    cattr_accessor :mapping, ['GET', '/test1']
    def call
      response
    end
  end

  class ComplexRouteWithMathcing < Surf::HttpRoute
    cattr_accessor :mapping, ['GET', '/test2/:id/pattern/:name']
    def call
      response.tap { |r| r.body = [match[:id] + match[:name]] }
    end
  end
end

describe Surf::Router do
  include Rack::Test::Methods

  let(:app) { Surf::Router.new([Fake::SimpleRoute, Fake::ComplexRouteWithMathcing]) }

  context 'when there is no any routing' do
    it 'return 404 code' do
      get '/'
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
