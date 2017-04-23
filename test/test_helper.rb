# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'surf'

Dir['test/support/**/*.rb'].each { |f| require f.sub('test/', '') }

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
