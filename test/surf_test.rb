# frozen_string_literal: true

require 'test_helper'

describe Surf do
  subject do
    Surf.dup
  end

  it 'has_a_version_number' do
    refute_nil ::Surf::VERSION
  end

  context '.configure' do
    it 'yields the Configuration object' do
      subject.configure do |config|
        config.port = 27
      end
      assert_equal 27, subject.port
    end
  end
end
