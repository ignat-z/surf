# frozen_string_literal: true

module RouteMatcher
  def regex_matcher(path, pattern)
    parsed_pattern = pattern.split('/').map do |part|
      part =~ /\A:.+/ ? "(?<#{part.delete(':')}>[^\/]*)" : part
    end.join('/')
    path.match(Regexp.new(parsed_pattern))
  end
end
