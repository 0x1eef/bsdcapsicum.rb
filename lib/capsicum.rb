# frozen_string_literal: true

require "capsicum/version"
require "fiddle"

module Capsicum
  # @api private
  module LibC
    module_function

    ##
    # Provides a Ruby interface for cap_enter(2)
    # @return [Integer]
    def cap_enter
      Fiddle::Function.new(
        libc["cap_enter"],
        [],
        Fiddle::Types::INT
      ).call
    end

    ##
    # Provides a Ruby interface for cap_getmode(2)
    # @param [Fiddle::Pointer] uintp
    # @return [Integer]
    def cap_getmode(uintp)
      Fiddle::Function.new(
        libc["cap_getmode"],
        [Fiddle::Types::INTPTR_T],
        Fiddle::Types::INT
      ).call(uintp)
    end

    ##
    # @api private
    def libc
      @libc ||= Fiddle.dlopen Dir["/lib/libc.*"].first
    end
  end

  module_function

  ##
  # Check if we're in capability mode.
  #
  # @see cap_getmode(2)
  # @raise [SystemCallError]
  #  Might raise a subclass of SystemCallError
  # @return [Boolean]
  #  Returns true if the current process is in capability mode
  def sandboxed?
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
  alias_method :capability_mode?, :sandboxed?

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

  # Run the block within a forked process in capability mode and wait for it to
  # complete.
  #
  # @yield block to run within the forked child.
  # @return [Process::Status] exit status of the forked child.
  def within_sandbox
    raise NotImplementedError, "fork() not supported" unless Process.respond_to? :fork

    return enum_for(:within_sandbox) unless block_given?

    pid = fork do
      Capsicum.enter!
      yield
    end

    Process.waitpid2(pid).last
  end
end
