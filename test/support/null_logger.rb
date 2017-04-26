# frozen_string_literal: true

require 'logger'
NULL_LOGGER = Logger.new('/dev/null')
Surf.configure { |config| config.logger = NULL_LOGGER }
