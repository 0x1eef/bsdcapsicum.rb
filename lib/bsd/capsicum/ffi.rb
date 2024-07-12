# frozen_string_literal: true

module BSD::Capsicum
  module FFI
    require "fiddle"
    require "fiddle/import"
    extend Fiddle::Importer
    dlload Dir["/lib/libc.*"].first

    include Fiddle::Types
    include Constants
    extern "int cap_getmode(u_int*)"
    extern "int cap_enter(void)"
    extern "int cap_rights_limit(int, const cap_rights_t*)"
    extern "cap_rights_t* __cap_rights_init(int version, cap_rights_t*, ...)"

    module_function

    ##
    # Provides a Ruby interface for cap_enter(2)
    # @return [Integer]
    def cap_enter
      self["cap_enter"].call
    end

    ##
    # Provides a Ruby interface for cap_getmode(2)
    # @param [Fiddle::Pointer] uintp
    # @return [Integer]
    def cap_getmode(uintp)
      self["cap_getmode"].call(uintp)
    end

    ##
    # Provides a Ruby interface for cap_rights_limit(2)
    # @param [Integer] fd
    # @param [Fiddle::Pointer] rights
    # @return [Integer]
    def cap_rights_limit(fd, rights)
      self["cap_rights_limit"].call(fd, rights)
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
      self["__cap_rights_init"].call(
        CAP_RIGHTS_VERSION,
        rights,
        *capabilities.flat_map {
          [ULONG_LONG, (Symbol === _1) ? Constants.const_get(_1) : _1]
        }
      )
    end
  end
  private_constant :FFI
end
