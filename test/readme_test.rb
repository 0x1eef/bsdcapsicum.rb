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
     "[child] Enter capability mode: ok\n",
     "[child] In capability mode: yes\n",
     "[child] Exit\n",
     "[parent] In capability mode: no\n"
    ].each { assert_match(/#{Regexp.escape(_1)}/, r.stdout) }
  end

  def test_3_set_rights_example
    r = ruby(readme_example("3_set_rights_example.rb"))
    ["[parent] Obtain file descriptor (with full capabilities)\n",
     "[child] Reduce capabilities to read\n",
     "[child] Read OK\n",
     %r|\[child\] Error:.+\(Errno::ENOTCAPABLE\)\n|,
     "[parent] Write OK\n"
    ].each { assert_match((Regexp === _1) ? _1 : /#{Regexp.escape(_1)}/, r.stdout) }
  ensure
    FileUtils.rm File.join(Dir.tmpdir, "bsdcapsicum.txt")
  end

  def test_4_fcntl_example
    r = ruby(readme_example("4_fcntl_example.rb"))
    ["Obtain file descriptor (with full capabilities)",
     "Reduce capabilities to fcntl",
     "Reduces fcntl capabilties to GETFL",
     "Get fcntl flags: OK",
     "Try to set fcntls flag ...",
     "Error: Capabilities insufficient @ finish_narg - /tmp/bsdcapsicum.txt (Errno::ENOTCAPABLE)"
    ].each { assert_match((Regexp === _1) ? _1 : /#{Regexp.escape(_1)}/, r.stdout) }
  ensure
    FileUtils.rm File.join(Dir.tmpdir, "bsdcapsicum.txt")
  end

  private

  def ruby(*argv)
    cmd("ruby", *argv)
  end

  def readme_example(example_name)
    File.join(__dir__, "..", "share", "examples", "bsdcapsicum.rb", example_name)
  end
end
