# frozen_string_literal: true

require 'test_helper'
require 'rack/test'
require 'surf/endpoints/home_page'

describe Surf::HomePage do
  let(:template) { "Hello, <%= request.session[:user].dig('info', 'name') %>" }
  let(:env) do
    {
      'REQUEST_METHOD' => 'GET',
      'REQUEST_PATH' => '/home/programmer',
      'PATH_INFO' => '/home/programmer',
      'rack.session' => { user: { 'info' => { 'name' => 'programmer' } } }
    }
  end

  subject do
    Surf::HomePage.dup.tap do |config|
      config.template = template
    end.new(env)
  end

  it 'calls home page processor' do
    result = subject.call
    assert_match(/Hello, programmer/, result.body.first)
  end
end
