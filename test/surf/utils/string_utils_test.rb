# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/string_utils'

describe StringUtils do
  TempClass = Class.new
  TempClass.send(:include, StringUtils)

  subject do
    TempClass.new
  end

  context '#demodulize' do
    it 'removes module info from classname' do
      assert_equal 'B', subject.demodulize('A::B')
    end

    it 'works for multimodule classes' do
      assert_equal 'C', subject.demodulize('A::B::C')
    end
  end

  context '#camelize' do
    it 'camelize module/snake_case_word' do
      assert_equal 'Module::SnakeCaseWord', subject.camelize('module/snake_case_word')
    end
  end

  context '#underscore' do
    it 'underscores cameCasedWord' do
      assert_equal 'a/b/idd_qd', subject.underscore('A::B::IddQd')
    end
  end
end
