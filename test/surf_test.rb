# frozen_string_literal: true

require 'test_helper'

describe Surf do
  it 'has_a_version_number' do
    refute_nil ::Surf::VERSION
  end
end
