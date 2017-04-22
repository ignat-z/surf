# frozen_string_literal: true

require 'test_helper'
require 'rack/test'
require 'surf/webhook_handler'

describe Surf::WebhookHandler do
  let(:webhook_body) { File.read('test/fixtures/webhook_registration.json') }
  let(:invalid_secret) { '1234567890' }
  let(:secret) { '123456789' }
  let(:env) do
    {
      'rack.input' => StringIO.new(webhook_body),
      'REQUEST_METHOD' => 'POST',
      'HTTP_X_GITHUB_EVENT' => 'ping',
      'HTTP_X_HUB_SIGNATURE' => 'sha1=03a5a335a3e0c2b927229092ef27ad2aa29f8053'
    }
  end

  context 'with invalid signature' do
    subject do
      Surf::WebhookHandler.configuration do |config|
        config.secret = invalid_secret
      end.new(env, {})
    end

    it 'return 500 error if webhook does not have valid signature' do
      result = subject.call

      refute result.ok?
      assert_equal result.status, 500
    end
  end

  class SimpleCallback
    extend Configuration
    cattr_accessor :called, 0
    def initialize(context)
      @context = context
      self.class.called += 1
    end

    def call
      @context.response
    end
  end

  subject do
    klass = Surf::WebhookHandler.dup.configuration do |config|
      config.secret = secret
      config.default_callback = SimpleCallback
    end
    klass.add_callback(event: 'ping', callback: SimpleCallback)
    klass.new(env, {})
  end

  it 'calls passed callbacks and default callback' do
    result = subject.call
    result.status
    assert_equal 2, SimpleCallback.called
  end
end
