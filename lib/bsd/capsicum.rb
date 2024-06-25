# frozen_string_literal: true

module BSD
end unless defined?(BSD)

module BSD::Capsicum
  require_relative "capsicum/version"
  require_relative "capsicum/ffi"
  extend self

  ##
  # Check if we're in capability mode.
  #
  # @see https://man.freebsd.org/cgi/man.cgi?query=cap_getmode&apropos=0&sektion=2&format=html cap_getmode(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true when the current process is in capability mode
  def in_capability_mode?
    uintp = Fiddle::Pointer.malloc(Fiddle::SIZEOF_UINT)
    FFI.cap_getmode(uintp)
    if FFI.cap_getmode(uintp).zero?
      uintp[0, Fiddle::SIZEOF_UINT].unpack("i") == [1]
    else
      raise SystemCallError.new("cap_getmode", Fiddle.last_error)
    end
  ensure
    uintp.call_free
  end
  alias_method :capability_mode?, :in_capability_mode?

  ##
  # Enter a process into capability mode
  #
  # @see https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html cap_enter(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true when successful
  def enter!
    return true unless FFI.cap_enter == -1
    raise SystemCallError.new("cap_enter", Fiddle.last_error)
  end
end
