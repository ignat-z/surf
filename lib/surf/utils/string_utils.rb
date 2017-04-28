# frozen_string_literal: true

module StringUtils
  def demodulize(path)
    if (i = path.rindex('::'))
      path[(i + 2)..-1]
    else
      path
    end
  end

  def camelize(snake_case_word)
    snake_case_word.sub(/^[a-z\d]*/, &:capitalize).tap do |string|
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) do
        "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
      end
      string.gsub!('/', '::')
    end
  end

  def underscore(camel_cased_word)
    camel_cased_word.to_s.dup.tap do |word|
      word.gsub!('::', '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
    end
  end
end
