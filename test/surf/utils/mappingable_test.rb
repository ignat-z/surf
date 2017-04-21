# frozen_string_literal: true

require 'test_helper'
require 'surf/repository'

describe Mappingable do
  class MappingableClass
    include Mappingable

    def initialize(body)
      create_mapping(body)
    end
  end

  subject do
    MappingableClass
      .dup
      .configuration { |config| config.mapping = mapping }
      .new(body)
  end

  let(:body) { { a: 1, b: { c: 42 } } }
  let(:mapping) { { value: %i[b c] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.value, 42
  end
end
