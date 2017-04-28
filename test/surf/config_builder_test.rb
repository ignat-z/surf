# frozen_string_literal: true

require 'test_helper'
require 'surf/config_builder'

YAML_CONFIG = <<~CONFIGURATION
  surf:
    adapter: fake_store/myhub
    application:
     key_1: value_1
     key_2: value_2
    endpoints:
     - surf/config_builder
    webhook_callbacks:
    - event: pull_request
      action: closed
      callback: surf/config_builder
    - event: ping
      callback: surf
CONFIGURATION

describe Surf::ConfigBuilder do
  let(:application) { FakeStore::Application.new }
  subject do
    Surf::ConfigBuilder.dup.tap do |config|
      config.application = application
      config.router = application
      config.webhook_handler = application
    end.new(YAML_CONFIG)
  end

  before { subject.build! }

  it 'calls build on adapter class' do
    assert_equal :called, FakeStore::Myhub.called
  end

  it 'returns application group as hash' do
    assert_equal 'value_1', application.key_1
  end

  it 'casts values from endpoints' do
    assert_equal [Surf::ConfigBuilder], application.default_routes
  end

  it 'returns casted callbacks settings' do
    assert_equal [
      { "event": 'pull_request', "action": 'closed', "callback": Surf::ConfigBuilder },
      { "event": 'ping', "callback": Surf }
    ], application.callbacks
  end
end
