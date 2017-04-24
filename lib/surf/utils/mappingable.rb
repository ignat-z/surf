# frozen_string_literal: true

require 'surf/utils/configurationable'

module Mappingable
  def self.included(base)
    base.extend Configurationable
    base.cattr_accessor :mapping, {}
  end

  private

  def create_mapping(body)
    self.class.mapping.each do |method_name, hash_path|
      define_singleton_method(method_name) do
        body.dig(*hash_path)
      end
    end
  end
end
