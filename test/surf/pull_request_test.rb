# frozen_string_literal: true

require 'test_helper'
require 'surf/pull_request'

describe Surf::PullRequest do
  module Fake
    class ContentProvider
      def pull_request(_repo, _id)
        { a: { b: { c: 23 } } }
      end
    end
  end

  subject do
    Surf::PullRequest
      .dup
      .configuration do |config|
        config.content_provider = Fake::ContentProvider
        config.mapping = mapping
      end.new(Fake::Repo.new(nil), 42)
  end

  let(:webhook) { Fixtures.webhook_registration }
  let(:mapping) { { value: %i[a b c] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.value, 23
  end
end
