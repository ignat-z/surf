# frozen_string_literal: true

require 'test_helper'
require 'surf/callbacks/ping_webhook_saver'

module Fake
  class Repo
    def initialize(_); end

    def id
      27
    end
  end

  class Context
    def raw_body
      { repository: { id: 27 } }.to_json
    end
  end

  class Storage
    def save(id:, value:)
      value && (id == 27)
    end
  end
end

describe Surf::PingWebhookSaver do
  subject do
    Surf::PingWebhookSaver
      .dup
      .configuration do |config|
        config.storage = Fake::Storage.new
        config.repositroy_class = Fake::Repo
      end.new(Fake::Context.new)
  end

  context '#call' do
    it 'saves webhook body to storage' do
      assert subject.call
    end
  end
end
