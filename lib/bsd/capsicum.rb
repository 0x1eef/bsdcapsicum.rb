# frozen_string_literal: true

module BSD
end unless defined?(BSD)

module BSD::Capsicum
  require "bsdcapsicum.rb.so"
  require_relative "capsicum/version"
  require_relative "capsicum/ffi"
  require_relative "capsicum/constants"
  extend self

  ##
  # Check if we're in capability mode
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
  alias_method :enter_cap_mode!, :enter!

  ##
  # Limit the capabilities of a file descriptor
  # @see https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&apropos=0&sektion=2&format=html cap_rights_limit(2)
  # @see BSD::Capsicum::Constants See Constants for a full list of capabilities
  # @example
  #   # Permit standard output operations to read and write
  #   BSD::Capsicum.permit!(STDOUT, :CAP_READ, :CAP_WRITE)
  #   # Ditto
  #   BSD::Capsicum.permit!(STDOUT, :read, :write)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @param [#fileno,#to_i] io
  #  An IO object
  # @param [Array<Symbol, Integer>] caps
  #  An allowed set of capabilities
  # @param [Symbol] scope
  #  The scope of the permit, either `nil` or `:fcntl`
  # @return [Boolean]
  #  Returns true when successful
  def permit!(io, *caps, scope: :rights)
    if scope == :fcntl
      FFI.cap_fcntls_limit(io.to_i, caps).zero? ||
        raise(SystemCallError.new("cap_fcntls_limit", Fiddle.last_error))
    elsif scope == :rights
      rightsp = Fiddle::Pointer.malloc(Constants::SIZEOF_CAP_RIGHTS_T)
      FFI.cap_rights_init(rightsp, *caps)
      FFI.cap_rights_limit(io.to_i, rightsp).zero? ||
        raise(SystemCallError.new("cap_rights_limit", Fiddle.last_error))
    else
      raise ArgumentError, "invalid scope: #{scope}"
    end
  ensure
    rightsp&.call_free
  end

  ##
  # This module is included into Ruby's IO class
  module IO
    ##
    # Limit the capabilities of a file descriptor
    # @param [Array<Symbol, Integer>] caps
    #  An allowed set of capabilities
    # @param [Symbol] scope
    #  The scope of the permit, either `nil` or `:fcntl`
    # @see BSD::Capsicum::Constants See CAP_FCNTLS_* for a full list of capabilities
    # @see BSD::Capsicum::Constants See CAP_* for a full list of capabilities
    def permit!(*caps, scope: :rights)
      BSD::Capsicum.permit!(self, *caps, scope:)
    end
  end
end

class IO
  include BSD::Capsicum::IO
end
