# frozen_string_literal: true

require "test_helper"

class CapsicumTest < Minitest::Test
  # This is going to get awkward...
  i_suck_and_my_tests_are_order_dependent!

  def test_that_it_has_a_version_number
    refute_nil ::Capsicum::VERSION
  end

  # After this test we're in capability mode and cannot escape.
  def test_1_capsicum
    refute Capsicum.in_capability_mode?
    assert Capsicum.enter!
    assert Capsicum.enter!
    assert Capsicum.in_capability_mode?

    assert_raises(Errno::ECAPMODE) do
      File.new(File::NULL)
    end

    assert_raises(Errno::ENOENT) do
      puts `ls`
    end
  end
end
