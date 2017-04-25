# frozen_string_literal: true

require 'test_helper'
require 'surf/repository'

module Fake
  class InitializerTest
    def initialize(*args); end

    def result
      :called
    end
  end
end

describe Surf::Repository do
  subject do
    Surf::Repository
      .dup
      .configuration do |config|
        config.mapping = mapping
        config.pull_request_class = Fake::InitializerTest
      end.new(webhook)
  end

  let(:webhook) { Fixtures.webhook_registration }
  let(:mapping) { { pulls_url: %w[repository pulls_url] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.pulls_url,
                 'https://api.github.com/repos/reponame/appname/pulls{/number}'
  end

  context '#pull_request' do
    it 'creates pull request instance with self and id' do
      assert_equal :called, subject.pull_request(42).result
    end
  end
end
