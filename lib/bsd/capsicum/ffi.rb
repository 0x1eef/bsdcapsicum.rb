# frozen_string_literal: true

module BSD::Capsicum
  module FFI
    require "fiddle"
    include Fiddle::Types
    include Constants

    module_function

    ##
    # Provides a Ruby interface for cap_enter(2)
    # @return [Integer]
    def cap_enter
      Fiddle::Function.new(
        libc["cap_enter"],
        [],
        INT
      ).call
    end

    ##
    # Provides a Ruby interface for cap_getmode(2)
    # @param [Fiddle::Pointer] uintp
    # @return [Integer]
    def cap_getmode(uintp)
      Fiddle::Function.new(
        libc["cap_getmode"],
        [INTPTR_T],
        INT
      ).call(uintp)
    end

    ##
    # Provides a Ruby interface for cap_rights_limit(2)
    # @param [Integer] fd
    # @param [Fiddle::Pointer] rights
    # @return [Integer]
    def cap_rights_limit(fd, rights)
      Fiddle::Function.new(
        libc["cap_rights_limit"],
        [INT, VOIDP],
        INT
      ).call(fd, rights)
    end

    ##
    # Provides a Ruby interface for cap_rights_init(2)
    # @see BSD::Capsicum::Constants See Constants for a full list of capabilities
    # @param [Fiddle::Pointer] rights
    #  A pointer to initialize the `cap_rights_t` structure
    # @param [Array<Integer>] capabilities
    #  An allowed set of capabilities
    # @return [Fiddle::Pointer]
    #  Returns a pointer to the structure `cap_rights_t`
    def cap_rights_init(rights, *capabilities)
      varargs = capabilities.flat_map { [ULONG_LONG, (Symbol === _1) ? Constants.const_get(_1) : _1] }
      Fiddle::Function.new(
        libc["__cap_rights_init"],
        [INT, VOIDP, VARIADIC],
        VOIDP
      ).call(CAP_RIGHTS_VERSION, rights, *varargs)
    end

    ##
    # @api private
    def libc
      @libc ||= Fiddle.dlopen Dir["/lib/libc.*"].first
    end
  end
  private_constant :FFI
end
