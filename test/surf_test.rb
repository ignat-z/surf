require 'test_helper'

class SurfTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Surf::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
