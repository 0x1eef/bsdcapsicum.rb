# frozen_string_literal: true

module BSD::Capsicum
  module FFI
    require "fiddle"
    require "fiddle/import"
    include Fiddle::Types
    extend Fiddle::Importer
    dlload Dir["/lib/libc.*"].first

    extern "int cap_getmode(u_int*)"
    extern "int cap_enter(void)"
    extern "int cap_rights_limit(int, const cap_rights_t*)"
    extern "int cap_fcntls_limit(int, uint32_t)"
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
    # @param [Fiddle::Pointer] rightsp
    # @return [Integer]
    def cap_rights_limit(fd, rightsp)
      self["cap_rights_limit"].call(fd, rightsp)
    end

    ##
    # Provides a Ruby interface for cap_fcntls_limit(2)
    # @param [Integer] fd
    # @param [Array<Integer>] capabilities
    #  An allowed set of capabilities
    # @return [Integer]
    def cap_fcntls_limit(fd, capabilities)
      cap = Private.cap_lookup(capabilities, Private.cap_fcntls)
      self["cap_fcntls_limit"].call(fd, cap.inject(&:|))
    end

    ##
    # Provides a Ruby interface for cap_rights_init(2)
    # @see BSD::Capsicum::Constants See Constants for a full list of capabilities
    # @param [Fiddle::Pointer] rightsp
    #  A pointer to initialize the `cap_rights_t` structure
    # @param [Array<Symbol, Integer>] capabilities
    #  An allowed set of capabilities
    # @raise [TypeError]
    #  When an unknown capability is provided
    # @return [Fiddle::Pointer]
    #  Returns a pointer to the structure `cap_rights_t`
    def cap_rights_init(rightsp, *capabilities)
      cap = Private.cap_lookup(capabilities, Private.cap_all)
      self["__cap_rights_init"].call(
        CAP_RIGHTS_VERSION,
        rightsp,
        *cap.flat_map { [ULONG_LONG, _1] }
      )
    end

    module Private
      extend self
      ##
      # @api private
      # @return [Array<Integer>]
      #  Returns a list of capabilities (as integers)
      def cap_lookup(capabilities, allowed)
        capabilities.flat_map do |cap|
          if Integer === cap
            cap
          elsif allowed.include?(cap)
            FFI.const_get(cap)
          elsif allowed.include?(:"CAP_#{cap.upcase}")
            FFI.const_get(:"CAP_#{cap.upcase}")
          elsif allowed.include?(:"CAP_FCNTL_#{cap.upcase}")
            FFI.const_get(:"CAP_FCNTL_#{cap.upcase}")
          else
            raise TypeError, "unknown capability: #{cap}"
          end
        end
      end

      ##
      # @api private
      # @return [Array<Symbol>]
      #  Returns all known capabilities
      def cap_all
        @cap_all ||= Constants.constants.select { _1.to_s.start_with?("CAP_") }
      end

      ##
      # @api private
      # @return [Array<Symbol>]
      #  Returns all known fcntl capabilities
      def cap_fcntls
        @cap_fcntls ||= Constants.constants.select { _1.to_s.start_with?("CAP_FCNTL_") }
      end
    end
  end
  private_constant :FFI
end
