# frozen_string_literal: true

require 'test_helper'
require 'surf/pull_request'

describe Surf::PullRequest do
  module Fake
    class Repo
    end

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
        config.mapping = { value: %i[a b c] }
      end.new(Fake::Repo.new, 42)
  end

  let(:webhook) { File.read('test/fixtures/webhook_registration.json') }
  let(:mapping) { { pulls_url: %w[PullRequest pulls_url] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.value, 23
  end
end
