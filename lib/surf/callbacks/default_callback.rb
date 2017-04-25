# frozen_string_literal: true

module Surf
  class DefaultCallback
    def initialize(context)
      @context = context
    end

    def call
      context.response
    end

    private

    attr_reader :context
  end
end
