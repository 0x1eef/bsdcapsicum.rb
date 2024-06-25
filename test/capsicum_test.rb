# frozen_string_literal: true

require "test_helper"

class BSD::Capsicum::Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil BSD::Capsicum::VERSION
  end

  def test_in_capability_mode_default
    assert_equal false, BSD::Capsicum.in_capability_mode?
  end

  def test_capability_mode_ecapmode
    ch = xchan(:marshal)
    fork do
      BSD::Capsicum.enter!
      File.new(File::NULL)
    rescue Errno::ECAPMODE => ex
      ch.send(ex)
    end
    Process.wait
    assert_equal Errno::ECAPMODE, ch.recv.class
  ensure
    ch.close
  end

  def test_capability_mode_with_shell_command
    ch = xchan(:marshal)
    fork do
      BSD::Capsicum.enter!
      `ls`
    rescue Errno::ENOENT => ex
      ch.send(ex)
    end
    Process.wait
    assert_equal Errno::ENOENT, ch.recv.class
  ensure
    ch.close
  end

  def test_rights_limit_on_stdout
    ch = xchan(:marshal)
    fork do
      BSD::Capsicum.set_rights!($stdout, [])
      puts 123
    rescue Errno::ENOTCAPABLE => ex
      ch.send(ex)
    end
    Process.wait
    assert_equal Errno::ENOTCAPABLE, ch.recv.class
  end
end
