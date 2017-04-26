# frozen_string_literal: true

module Configurable
  def configuration
    yield self
    self
  end

  def cattr_accessor(name, default = nil, &block)
    value = block.nil? ? default : block
    class_variable_set("@@#{name}", value)

    define_cattr_reader(name)
    define_cattr_writer(name)
  end

  private

  def define_cattr_reader(name)
    define_class_method name do
      result = class_variable_get("@@#{name}")
      result.is_a?(Proc) && !result.lambda? ? result.call : result
    end
  end

  def define_cattr_writer(name)
    define_class_method "#{name}=" do |value|
      class_variable_set("@@#{name}", value)
    end
  end

  def define_class_method(name, &block)
    (class << self; self; end).instance_eval do
      define_method name, &block
    end
  end
end
