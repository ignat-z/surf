# frozen_string_literal: true

require 'test_helper'
require 'surf/repository'

describe Surf::Repository do
  subject do
    Surf::Repository
      .dup
      .configuration { |config| config.mapping = mapping }
      .new(webhook)
  end

  let(:webhook) { Fixtures.webhook_registration }
  let(:mapping) { { pulls_url: %w[repository pulls_url] } }

  it 'creates methods to allow use mapped keys' do
    assert_equal subject.pulls_url,
                 'https://api.github.com/repos/reponame/appname/pulls{/number}'
  end
end
