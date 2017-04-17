# frozen_string_literal: true

module Surf
  module Github
    class ContentProvider < Surf::ContentProvider
      def pull_request_info(repository, id)
        GithubRequest.new.get(repository.pull_request_url(id))
      end
    end
  end
end
