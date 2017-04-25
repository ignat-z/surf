# frozen_string_literal: true

require 'surf/utils/http_route'

module FakeStore
  class Repo
    def initialize(_); end

    def id
      27
    end
  end

  class Context
    def raw_body
      { repository: { id: 27 } }.to_json
    end
  end

  class ContentProvider
    def pull_request(_repo, _id)
      { a: { b: { c: 27 } } }
    end
  end

  class Storage
    def save(id:, value:)
      value && (id == 27)
    end
  end

  class InitializerTest
    def initialize(*args); end

    def result
      :called
    end
  end

  class SimpleRoute < Surf::HttpRoute
    cattr_accessor :route, ['GET', '/test1']
    def call
      response
    end
  end

  class ComplexRouteWithMathcing < Surf::HttpRoute
    cattr_accessor :route, ['GET', '/test2/:id/pattern/:name']
    def call
      response.tap { |r| r.body = [match[:id] + match[:name]] }
    end
  end
end
