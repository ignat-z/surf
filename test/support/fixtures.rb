# frozen_string_literal: true

module Fixtures
  module_function

  def webhook_registration
    @webhook_registration ||= File.read('test/fixtures/webhook_registration.json')
  end
end
