# frozen_string_literal: true

module BSD
end unless defined?(BSD)

module BSD::Capsicum
  require_relative "capsicum/version"
  require_relative "capsicum/constants"
  require_relative "capsicum/ffi"
  extend self

  ##
  # Check if we're in capability mode
  #
  # @see https://man.freebsd.org/cgi/man.cgi?query=cap_getmode&apropos=0&sektion=2&format=html cap_getmode(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true when the current process is in capability mode
  def in_capability_mode?
    uintp = Fiddle::Pointer.malloc(Fiddle::SIZEOF_UINT)
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
    FFI.cap_enter.zero? ||
    raise(SystemCallError.new("cap_enter", Fiddle.last_error))
  end
  alias_method :enter_capability_mode!, :enter!

  ##
  # Restrict the capabilities of a file descriptor
  #
  # @see https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&apropos=0&sektion=2&format=html cap_rights_limit(2)
  # @see BSD::Capsicum::Constants See Constants for a full list of capabilities
  # @example
  #   # Restrict capabilities of STDOUT to read / write
  #   BSD::Capsicum.set_rights!(STDOUT, %i[CAP_READ CAP_WRITE])
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @param [#to_i] io
  #  An IO object
  # @param [Array<String>] capabilities
  #  An allowed set of capabilities
  # @return [Boolean]
  #  Returns true when successful
  def set_rights!(io, capabilities)
    rights = Fiddle::Pointer.malloc(Constants::SIZEOF_CAP_RIGHTS_T)
    FFI.cap_rights_init(rights, *capabilities)
    FFI.cap_rights_limit(io.to_i, rights).zero? ||
    raise(SystemCallError.new("cap_rights_limit", Fiddle.last_error))
  ensure
    rights.call_free
  end
end
