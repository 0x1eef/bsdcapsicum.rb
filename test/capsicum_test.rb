# frozen_string_literal: true

require "test_helper"

class CapsicumTest < Minitest::Test
  # This is going to get awkward...
  i_suck_and_my_tests_are_order_dependent!

  def test_that_it_has_a_version_number
    refute_nil ::Capsicum::VERSION
  end

  def test_1_within_sandbox
    skip if RUBY_ENGINE == "jruby" # fork not supported

    refute Capsicum.sandboxed?

    result = Capsicum.within_sandbox do
      Capsicum.sandboxed? == true || Process.exit!(1)
      File.new(File::NULL)
    rescue Errno::ECAPMODE
      Process.exit!(0)
    else
      Process.exit!(2)
    end

    assert result.exitstatus.zero?
    refute Capsicum.sandboxed?
  end

  # After this test we're in capability mode and cannot escape.
  def test_2_capsicum
    refute Capsicum.sandboxed?
    assert Capsicum.enter!
    assert Capsicum.enter!
    assert Capsicum.sandboxed?

    assert_raises(Errno::ECAPMODE) do
      File.new(File::NULL)
    end

    assert_raises(Errno::ENOENT) do
      puts `ls`
    end
  end
end
