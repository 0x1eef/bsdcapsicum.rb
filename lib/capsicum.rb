# frozen_string_literal: true

module Capsicum
  require_relative "capsicum/version"
  require_relative "capsicum/libc"
  module_function

  ##
  # Check if we're in capability mode.
  #
  # @see cap_getmode(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true when the current process is in capability mode
  def in_capability_mode?
    uintp = Fiddle::Pointer.malloc(Fiddle::SIZEOF_UINT)
    ret = LibC.cap_getmode(uintp)

    if ret == 0
      uintp[0, Fiddle::SIZEOF_UINT].unpack("i") == [1]
    else
      raise SystemCallError.new("cap_getmode", Fiddle.last_error)
    end
  ensure
    uintp.call_free
  end

  ##
  # Enter capability mode
  #
  # @see cap_enter(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true when the current process is in capability mode
  def enter!
    if LibC.cap_enter == 0
      true
    else
      raise SystemCallError.new("cap_enter", Fiddle.last_error)
    end
  end
end
