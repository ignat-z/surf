# frozen_string_literal: true

class Lazy
  def initialize(&block)
    @block = block
  end

  def cast
    @block.call
  end
end

module Configurable
  def configuration
    yield self
    self
  end

  def cattr_accessor(name, default = nil)
    class_variable_set("@@#{name}", default)

    define_cattr_reader(name)
    define_cattr_writer(name)
  end

  private

  def define_cattr_reader(name)
    define_class_method name do
      result = class_variable_get("@@#{name}")
      result.is_a?(Lazy) ? result.cast : result
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
