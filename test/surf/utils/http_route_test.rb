# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/http_route'
require 'rack/test'

module Fake
  class Route < Surf::HttpRoute
    def call
      :response
    end
  end
end

describe Surf::HttpRoute do
  context '.mapping' do
    it 'returns error with description' do
      error = assert_raises { Surf::HttpRoute.mapping }
      assert_match(/provide tuple/, error.message)
    end
  end

  context '.call' do
    it 'create new instance of self class and calls call with all HTTP stuff' do
      result = Fake::Route.call({}, {})
      assert_equal result, :response
    end
  end

  context '#call' do
    it 'by default raises exception' do
      assert_raises { Surf::HttpRoute.new({}, {}).mapping }
    end
  end
end
