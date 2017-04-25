# frozen_string_literal: true

require 'test_helper'
require 'surf/configuration'

describe Surf::Configuration do
  let(:integer_caster) { ->(value) { value.to_i } }
  let(:attribute) { Surf::Configuration::ConfigurationParameter.new(:port, '3001', integer_caster) }

  subject do
    Surf::Configuration
      .dup
      .configuration do |config|
        config.attributes = [attribute]
      end.new
  end

  context '.new' do
    it 'initialize new class with default parameters and cast it' do
      assert_equal subject.port, 3001
    end
  end
end
