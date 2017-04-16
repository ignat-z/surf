# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'surf'

require 'minitest/autorun'

require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/mock'
require 'minitest/hell'

module Minitest
  class Test
    parallelize_me!
  end
end

module Kernel
  alias context describe
end
