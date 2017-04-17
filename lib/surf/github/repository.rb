# frozen_string_literal: true

require 'surf/mappingable'

module Surf
  module Github
    class Repository < Surf::Repository
      cattr_accessor :mapping, pulls_url: %w[repository pulls_url]

      def pull_request_url(id)
        pulls_url.gsub('{/number}', "/#{id}")
      end
    end
  end
end
