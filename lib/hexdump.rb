# frozen_string_literal: true

class Hexdump
  attr_reader(
    :stream, :word_size, :line_length, :hide_null, :line, :first_skip,
    :hiding_output
  )

  def initialize(stream, word_size: 4, line_length: 32, hide_null: true)
    @stream = stream
    @word_size = word_size
    @line_length = line_length
    @hide_null = hide_null
    @first_skip = true
    @hiding_output = false
  end

  def self.group_by(chars, by: 4, break_char: ' ')
    chars.scan(
      /.{1,#{by}}/
    ).join(break_char)
  end

  def self.group_by_line_and_word(chars, word_by: 4, line_by: 32)
    chars.scan(/.{1,#{line_by}}/).map do |line|
      group_by(line, by: word_by)
    end.join("\n")
  end

  ##
  # od -t x1 -A n <file-name>
  def to_s
    out = stream.scan(/.{1,#{line_length}}/).map do |line|
      @line = line
      next if skippable_line?

      if blank_line?
        if first_skip
          @first_skip = false
          self.class.group_by(line, by: word_size)
        else
          @hiding_output = true
          '*'
        end
      else
        @hiding_output = false
        @first_skip = true
        self.class.group_by(line, by: word_size)
      end
    end
    out.compact.join("\n")
  end

  def blank_line?
    line.match(/^0*$/)
  end

  def skippable_line?
    blank_line? && hiding_output && !first_skip
  end
end
