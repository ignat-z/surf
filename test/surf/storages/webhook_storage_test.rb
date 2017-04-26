# frozen_string_literal: true

require 'mock_redis'
require 'test_helper'
require 'surf/storages/webhook_storage'

describe Surf::WebhookStorage do
  subject do
    Surf::WebhookStorage
      .dup
      .tap do |config|
        config.redis = MockRedis.new
      end.new
  end

  context '#save' do
    it 'persists value by passed id in storage' do
      assert subject.save(id: 27, value: 'iddqd')
    end
  end

  context '#find' do
    it 'returns nil if there is no such key in storage' do
      assert_nil subject.find(id: 27)
    end
  end

  context '#all' do
    it 'returns all values from storage' do
      assert_equal [], subject.all
    end
  end

  context 'integration' do
    it 'allows to use storage' do
      assert subject.save(id: 27, value: 'iddqd')
      assert subject.save(id: 42, value: 'idkfa')
      assert_equal 'iddqd', subject.find(id: 27)
      assert_equal %w[iddqd idkfa], subject.all.sort
    end
  end
end
