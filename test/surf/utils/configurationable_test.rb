# frozen_string_literal: true

require 'test_helper'
require 'surf/utils/configurationable'

describe Configurationable do
  class ExtendableClass
    extend Configurationable

    cattr_accessor :simple_setting
    cattr_accessor :setting_with_default, 42
  end

  it 'defines class variables with curresponding default values' do
    assert_equal ExtendableClass.class_variables,
                 %i[@@simple_setting @@setting_with_default]
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
end
