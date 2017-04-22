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
  context '.route' do
    it 'returns error with description' do
      error = assert_raises { Surf::HttpRoute.route }
      assert_match(/provide tuple/, error.message)
    end
  end

  context '#call' do
    it 'by default raises exception' do
      assert_raises { Surf::HttpRoute.new({}, {}).call }
    end
  end
end
