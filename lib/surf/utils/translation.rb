# frozen_string_literal: true

require 'i18n'
require 'i18n/backend/fallbacks'

module Translation
  def self.extended(base)
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    base.load_locales(Dir['./config/locales/*.{yml}'])

    base.extend Forwardable
    base.def_delegator :I18n, :t
  end

  def load_locales(paths)
    I18n.load_path.concat(Array(paths))
    I18n.reload!
  end

  def locale=(new_locale)
    I18n.locale = new_locale
  end
end
