# @api private
module Capsicum::LibC
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
