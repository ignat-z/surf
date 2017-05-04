# frozen_string_literal: true

require 'test_helper'
require 'rack/test'
require 'surf/endpoints/webhook_handler'

describe Surf::WebhookHandler do
  let(:webhook) { Fixtures.webhook_registration }
  let(:invalid_secret) { '1234567890' }
  let(:secret) { '123456789' }
  let(:env) do
    {
      'rack.input' => StringIO.new(webhook),
      'REQUEST_METHOD' => 'POST',
      'PATH_INFO' => '/webhook',
      'HTTP_X_GITHUB_EVENT' => 'ping',
      'HTTP_X_HUB_SIGNATURE' => 'sha1=f2312c549bf523dc66c1cbff319c02048f5d534c'
    }
  end

  context 'with invalid signature' do
    subject do
      Surf::WebhookHandler.dup.configuration do |config|
        config.secret = invalid_secret
      end.new(env)
    end

    it 'return 500 error if webhook does not have valid signature' do
      result = subject.call

      refute result.ok?
      assert_equal result.status, 500
    end
  end

  context 'without any callback on action' do
    subject do
      Surf::WebhookHandler.dup.configuration do |config|
        config.secret = secret
        config.callbacks = {}
      end.new(env)
    end

    it 'uses default action and return success response' do
      result = subject.call
      assert result.ok?
    end
  end

  class SimpleCallback
    extend Configurable
    cattr_accessor(:called, 0)
    def initialize(context)
      @context = context
      self.class.called += 1
    end

    def call
      @context.response
    end
  end

  context 'when mapping contains callback on cation' do
    let(:callback) { SimpleCallback.dup }

    subject do
      klass = Surf::WebhookHandler.dup.configuration do |config|
        config.secret = secret
        config.default_callback = callback
      end
      klass.add_callback(event: 'ping', callback: callback)
      klass.new(env)
    end

    it 'calls passed callbacks and default callback' do
      result = subject.call
      result.status
      assert_equal 2, callback.called
    end
  end
end
