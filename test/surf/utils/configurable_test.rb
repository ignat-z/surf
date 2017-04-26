# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/configurable'

describe Configurable do
  class ExtendableClass
    extend Configurable

    cattr_accessor :simple_setting
    cattr_accessor :setting_with_default, 42
    cattr_accessor :lazy_value, Lazy.new(-> { raise(ArgumentError) })
  end

  it 'defines class variables with curresponding default values' do
    assert_equal ExtendableClass.class_variables,
                 %i[@@simple_setting @@setting_with_default @@lazy_value]
  end

  it 'defines reader methods for extended class' do
    assert_respond_to ExtendableClass, :simple_setting
    assert_respond_to ExtendableClass, :setting_with_default
  end

  it 'defines write accessor for extended class' do
    assert_respond_to ExtendableClass, :simple_setting=
    assert_respond_to ExtendableClass, :setting_with_default=
  end

  it 'allows to set class variables in configuration block' do
    ExtendableClass.configuration do |config|
      config.simple_setting = :value
      config.setting_with_default = 29
    end

    assert_equal ExtendableClass.setting_with_default, 29
    assert_equal ExtendableClass.simple_setting, :value
  end

  it 'allows to set lazy values by wrapping it with lazy and lambda' do
    assert_raises(ArgumentError) { ExtendableClass.lazy_value }
  end
end
