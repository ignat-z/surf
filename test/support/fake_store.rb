# frozen_string_literal: true

require 'surf/utils/http_route'

module FakeStore
  REPOSITORY_ID = 27
  REPOSITORY_DESCRIPTION = { repository: { id: REPOSITORY_ID } }.freeze

  class Repo
    def initialize(_); end

    def id
      27
    end
  end

  class Context
    def raw_body
      REPOSITORY_DESCRIPTION.to_json
    end
  end

  class ContentProvider
    def pull_request(_repo, _id)
      { a: { b: { c: REPOSITORY_ID } } }
    end
  end

  class Storage
    def save(id:, value:)
      value && (id == REPOSITORY_ID)
    end
  end

  class InitializerTest
    def initialize(*args); end

    def result
      :called
    end
  end

  class SimpleRoute < Surf::HttpRoute
    cattr_accessor(:route, ['GET', '/test1'])
    def call
      response
    end
  end

  class ComplexRouteWithMathcing < Surf::HttpRoute
    cattr_accessor(:route, ['GET', '/test2/:id/pattern/:name'])
    def call
      response.tap { |r| r.body = [match[:id] + match[:name]] }
    end
  end

  class WebhookStorage
    def all
      [REPOSITORY_DESCRIPTION.to_json]
    end

    def find(*)
      REPOSITORY_DESCRIPTION.to_json
    end
  end
end
