# frozen_string_literal: true

require 'test_helper'
require 'surf/content_provider'

describe Surf::ContentProvider do
  subject { Surf::ContentProvider.new }

  %w[pull_request].each do |method_name|
    it "should respond to #{method_name}" do
      assert_respond_to(subject, method_name)
    end
  end
end
