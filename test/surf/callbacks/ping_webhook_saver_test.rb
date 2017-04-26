# frozen_string_literal: true

require 'test_helper'
require 'surf/callbacks/ping_webhook_saver'

describe Surf::PingWebhookSaver do
  subject do
    Surf::PingWebhookSaver
      .dup
      .configuration do |config|
        config.storage = FakeStore::Storage.new
        config.repository_class = FakeStore::Repo
      end.new(FakeStore::Context.new)
  end

  context '#call' do
    it 'saves webhook body to storage' do
      assert subject.call
    end
  end
end
