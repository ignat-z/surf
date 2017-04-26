# frozen_string_literal: true

require 'test_helper'
require 'surf/repository'

describe Surf::Repository do
  subject do
    Surf::Repository
      .dup
      .configuration do |config|
        config.mapping = mapping
        config.pull_request_class = FakeStore::InitializerTest
        config.webhook_storage = FakeStore::WebhookStorage.new
      end
  end

  let(:webhook) { Fixtures.webhook_registration }
  let(:mapping) { { pulls_url: %w[repository pulls_url], id: %w[repository id] } }

  it 'creates methods to allow use mapped keys' do
    assert_match %r[pulls{/number}], subject.new(webhook).pulls_url
  end

  context '#pull_request' do
    it 'creates pull request instance with self and id' do
      assert_equal :called, subject.new(webhook).pull_request(42).result
    end
  end

  context '.all' do
    it 'retreives all saved webhooks and wraps it to repo object' do
      assert_equal 1, subject.all.count
      assert_equal 27, subject.all.first.id
    end
  end

  context '.find' do
    it 'retrives passed webhook by id and wrap it to repo object' do
      assert_equal 27, subject.find(id: 42).id
    end
  end
end
