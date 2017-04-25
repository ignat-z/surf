# frozen_string_literal: true

require 'test_helper'
require 'surf/pull_request'

describe Surf::PullRequest do
  subject do
    Surf::PullRequest
      .dup
      .configuration do |config|
        config.content_provider = FakeStore::ContentProvider
        config.mapping = mapping
      end.new(FakeStore::Repo.new(nil), 42)
  end

  let(:webhook) { Fixtures.webhook_registration }
  let(:mapping) { { value: %i[a b c] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.value, 27
  end
end
