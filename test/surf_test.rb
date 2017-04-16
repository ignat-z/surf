require 'test_helper'

class SurfTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Surf::VERSION
  end
end
