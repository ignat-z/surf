# frozen_string_literal: true

module StringUtils
  def demodulize(path)
    if (i = path.rindex('::'))
      path[(i + 2)..-1]
    else
      path
    end
  end

  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!('::', '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!('-', '_')
    word.downcase!
    word
  end
end
