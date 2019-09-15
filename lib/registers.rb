# frozen_string_literal: true

##
# 64-bit register | Lower 32 bits | Lower 16 bits | Lower 8 bits
# ==============================================================
# rax             | eax           | ax            | al
# rbx             | ebx           | bx            | bl
# rcx             | ecx           | cx            | cl
# rdx             | edx           | dx            | dl
# rsi             | esi           | si            | sil
# rdi             | edi           | di            | dil
# rbp             | ebp           | bp            | bpl
# rsp             | esp           | sp            | spl
# r8              | r8d           | r8w           | r8b
# r9              | r9d           | r9w           | r9b
# r10             | r10d          | r10w          | r10b
# r11             | r11d          | r11w          | r11b
# r12             | r12d          | r12w          | r12b
# r13             | r13d          | r13w          | r13b
# r14             | r14d          | r14w          | r14b
# r15             | r15d          | r15w          | r15b
# NOTE: the above information is missing ah, bh etc.
class Register
  attr_reader :name, :context

  def initialize(name)
    @name = name
    @context = yield if block_given?
  end

  def width
    case name.to_s
    when /^[acdb][x]$/
      16
    when /^[acdb][lh]$/
      8
    end
  end

  def extension
    Support::EXTENSION[name]
  end

  module Support
    NAMES = [
      Set[:al, :ax, :eax, :mm0, :xmm0, :ymm0, :zmm0],
      Set[:cl, :cx, :ecx, :mm1, :xmm1, :ymm1, :zmm1],
      Set[:dl, :dx, :edx, :mm2, :xmm2, :ymm2, :zmm2],
      Set[:bl, :bx, :ebx, :mm3, :xmm3, :ymm3, :zmm3],
      Set[:ah, :sp, :esp, :mm4, :xmm4, :ymm4, :zmm4],
      Set[:ch, :bp, :ebp, :mm5, :xmm5, :ymm5, :zmm5],
      Set[:dh, :si, :esi, :mm6, :xmm6, :ymm6, :zmm6],
      Set[:bh, :di, :edi, :mm7, :xmm7, :ymm7, :zmm7]
    ].freeze

    HEX = [
      %i[C0 C1 C2 C3 C4 C5 C6 C7],
      %i[C8 C9 CA CB CC CD CE CF],
      %i[D0 D1 D2 D3 D4 D5 D6 D7],
      %i[D8 D9 DA DB DC DD DE DF],
      %i[E0 E1 E2 E3 E4 E5 E6 E7],
      %i[E8 E9 EA EB EC ED EE EF],
      %i[F0 F1 F2 F3 F4 F5 F6 F7],
      %i[F8 F9 FA FB FC FD FE FF]
    ].freeze

    ##
    # REGISTERS.each_with_index do |s, i|
    #   s.each { |r| order[r] = i }
    EXTENSION = {
      al: 0, ax: 0, eax: 0, mm0: 0, xmm0: 0, ymm0: 0, zmm0: 0,
      cl: 1, cx: 1, ecx: 1, mm1: 1, xmm1: 1, ymm1: 1, zmm1: 1,
      dl: 2, dx: 2, edx: 2, mm2: 2, xmm2: 2, ymm2: 2, zmm2: 2,
      bl: 3, bx: 3, ebx: 3, mm3: 3, xmm3: 3, ymm3: 3, zmm3: 3,
      ah: 4, sp: 4, esp: 4, mm4: 4, xmm4: 4, ymm4: 4, zmm4: 4,
      ch: 5, bp: 5, ebp: 5, mm5: 5, xmm5: 5, ymm5: 5, zmm5: 5,
      dh: 6, si: 6, esi: 6, mm6: 6, xmm6: 6, ymm6: 6, zmm6: 6,
      bh: 7, di: 7, edi: 7, mm7: 7, xmm7: 7, ymm7: 7, zmm7: 7
    }.freeze
    # REGISTERS = {
    #   al: 0xb0,
    #   cl: 0xb1,
    #   dl: 0xb2,
    #   bl: 0xb3,
    #   ah: 0xb4,
    #   ch: 0xb5,
    #   dh: 0xb6,
    #   bh: 0xb7,
    #   ax: 0xb8,
    #   cx: 0xb9,
    #   dx: 0xba,
    #   bx: 0xbb
    # }.freeze
  end
end

module Registers
  # AsmCodes::REGISTERS.each do |method, code|
  #   define_method method do
  #     to_hex(code)
  #   end
  # end
  Register::Support::NAMES.each do |line|
    line.each do |name|
      define_method(name) { Register.new(name) }
    end
  end
end

# "Set#{'AL/AX/EAX/MM0/XMM0/YMM0/ZMM0'.downcase.split('/').map(&:to_sym)}"
# data = %w[...].each_slice(8).map { |slice| '%i[' + slice.join(' ') + ']'}

# 'AL/AX/EAX/MM0/XMM0/YMM0/ZMM0
# CL/CX/ECX/MM1/XMM1/YMM1/ZMM1
# DL/DX/EDX/MM2/XMM2/YMM2/ZMM2
# BL/BX/EBX/MM3/XMM3/YMM3/ZMM3
# AH/SP/ESP/MM4/XMM4/YMM4/ZMM4
# CH/BP/EBP/MM5/XMM5/YMM5/ZMM5
# DH/SI/ESI/MM6/XMM6/YMM6/ZMM6
# BH/DI/EDI/MM7/XMM7/YMM7/ZMM7'.each_line.map do |line|
#   printf "Set#{line.strip.downcase.split('/').map(&:to_sym)}"
# end

# mov al, 0 ; b0 00
# mov cl, 0 ; b1 00
# mov dl, 0 ; b2 00
# mov bl, 0 ; b3 00
# mov ah, 0 ; b4 00
# mov ch, 0 ; b5 00
# mov dh, 0 ; b6 00
# mov bh, 0 ; b7 00
# mov ax, 0 ; b8 00 00
# mov cx, 0 ; b9 00 00
# mov dx, 0 ; ba 00 00
# mov bx, 0 ; bb 00 00
# def print_asm_codes
#   # al, ah, ax, eax?
#   base = 0xb0
#   count = 0
#   %w[l h x].each do |size|
#     %w[a c d b].each do |reg|
#       register = "#{reg}#{size}"
#       reg_addr = (base + count).to_s(16)
#       # word_size = '00' * 2 if size == 'x'
#       # puts "mov #{register}, 0 ; #{reg_addr}"
#       # puts "#{register}: 0x#{reg_addr},"
#       count += 1
#     end
#   end
# end
