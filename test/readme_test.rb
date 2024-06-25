require "test_helper"
require "test-cmd"

class ReadMeTest < Minitest::Test
  def test_1_capability_mode_example
    r = ruby(readme_example("1_capability_mode_example.rb"))
    assert_match %r|In capability mode: no\n|, r.stdout
    assert_match %r|Enter capability mode: ok\n|, r.stdout
    assert_match %r|In capability mode: yes\n|, r.stdout
    assert_match %r|Error:.+\(Errno::ECAPMODE\)\n|, r.stdout
  end

  private

  def ruby(*argv)
    cmd("ruby", *argv)
  end

  def readme_example(example_name)
    File.join(__dir__, "..", "share", "ruby-capsicum", "examples", example_name)
  end
end
