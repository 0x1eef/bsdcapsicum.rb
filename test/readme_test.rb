# frozen_string_literal: true

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

  def test_2_fork_example
    r = ruby(readme_example("2_fork_example.rb"))
    ["[parent] In capability mode: no\n",
     "[subprocess] Enter capability mode: ok\n",
     "[subprocess] In capability mode: yes\n",
     "[subprocess] Exit\n",
     "[parent] In capability mode: no\n"
    ].each { assert_match(/#{Regexp.escape(_1)}/, r.stdout) }
  end

  def test_3_set_rights_example
    r = ruby(readme_example("3_set_rights_example.rb"))
    ["[parent] Obtain file descriptor (with all capabilities)\n",
     "[subprocess] Reduce capabilities to read\n",
     "[subprocess] Read OK\n",
     %r|\[subprocess\] Error:.+\(Errno::ENOTCAPABLE\)\n|,
     "[parent] Write OK\n"
    ].each { assert_match((Regexp === _1) ? _1 : /#{Regexp.escape(_1)}/, r.stdout) }
  ensure
    FileUtils.rm File.join(Dir.home, "bsdcapsicum.txt")
  end

  private

  def ruby(*argv)
    cmd("ruby", *argv)
  end

  def readme_example(example_name)
    File.join(__dir__, "..", "share", "examples", "bsdcapsicum.rb", example_name)
  end
end
