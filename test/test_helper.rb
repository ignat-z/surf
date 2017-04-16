$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'surf'

require 'minitest/autorun'

require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "minitest/hell"

class Minitest::Test
  parallelize_me!
end

module Kernel
  alias_method :context, :describe
end
