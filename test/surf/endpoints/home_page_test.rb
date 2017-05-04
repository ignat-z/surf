# frozen_string_literal: true

require 'test_helper'
require 'rack/test'
require 'surf/endpoints/home_page'

describe Surf::HomePage do
  let(:env) do
    {
      'REQUEST_METHOD' => 'GET',
      'REQUEST_PATH' => '/home/programmer',
      'PATH_INFO' => '/home/programmer',
      'rack.session' => { user: { 'info' => { 'name' => 'programmer' } } }
    }
  end

  subject do
    Surf::HomePage.dup.new(env)
  end

  it 'calls home page processor' do
    result = subject.call
    assert_match(/Hello, programmer/, result.body.first)
  end
end
