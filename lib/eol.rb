module Kernel
  # Shorthand for EOL.sniff
  def EOL(string_or_io)
    ::EOL.sniff string_or_io
  end
end

# EOL is an end-of-line detector.
#
# Feed it a text string or IO and it'll answer these questions:
#
# * Is it binary? (Does it contain null bytes, non-printable chars, etc.)
# * Does it have \r\n (aka "DOS") or \n (aka "Unix") line endings?
#
# It'll also normalize line endings for you if you'd like to uniformly
# work with \r\n or \n.
module EOL
  class << self
    def sniff(string_or_io)
      stat(string_or_io).eol
    end

    def stat(string_or_io)
      Scanner.scan(string_or_io)
    end

    def convert(string, eol)
      Converter.convert(string, eol)
    end
  end

  class Stat
    attr_accessor :cr, :lf, :crlf, :nul, :printable, :nonprintable

    def initialize
      @cr = @lf = @crlf = @nul = @printable = @nonprintable = 0
    end

    # If it's not binary, it's text!
    def text?
      not binary?
    end

    # Classify as binary if there are any bare CR chars, any NUL bytes,
    # or a relatively high proportion of nonprintable chars.
    #
    # Same heuristic as git diff.c::mmfile_is_binary()
    def binary?
      @cr > 0 || @nul > 0 || (@printable >> 7) < @nonprintable
    end

    def eol
      if binary?
        :binary
      elsif @lf > 0
        if @crlf > 0
          :mixed
        else
          :lf
        end
      elsif @crlf > 0
        :crlf
      else
        :none
      end
    end
  end

  class Scanner
    def self.scan(string_or_io)
      new.scan(string_or_io)
    end

    def initialize
      @stat = Stat.new
    end

    def scan(string_or_io)
      if string_or_io.respond_to?(:read)
        scan_io string_or_io
      else
        scan_string string_or_io
      end

      @stat
    end

    private
      def scan_io(io)
        while chunk = io.read(8192)
          scan_string chunk
        end
      end

      def scan_string(string)
        string = string.dup.force_encoding('binary') if string.respond_to?(:force_encoding)

        i, size = 0, string.size
        while i < size
          case byte = string[i].ord
          when 13 # \r
            peek = string[i+1]
            if peek && peek.ord == 10 # \r\n
              @stat.crlf += 1
              i += 1
            else
              @stat.cr += 1
            end
          when 10 # \n
            @stat.lf += 1
          when 127 # DEL
            @stat.nonprintable += 1
          else
            if byte < 32 # ASCII control chars
              case byte
              when 8, 9, 12, 27 # BS, HT, FF, ESC
                @stat.printable += 1
              when 0 # NUL
                @stat.nul += 1
                @stat.nonprintable += 1
              else
                @stat.nonprintable += 1
              end
            else
              @stat.printable += 1
            end
          end

          i += 1
        end

        # Don't count final EOF as nonprintable since it's present in normal
        # text files.
        if !string.empty? && string[-1].ord == 26
          @stat.nonprintable -= 1
        end
      end
  end

  module Converter
    extend self

    def convert(string, eol)
      case current = EOL.sniff(string)
      when :binary
        raise "Can't convert a binary string to #{eol} newlines"
      when :none, eol
        string
      when :mixed, :lf, :crlf
        case eol
        when :lf
          to_lf string
        when :crlf
          to_crlf string
        else
          raise ArgumentError, "Unknown EOL requested: #{eol}"
        end
      else
        raise "String has unrecognized EOL: #{current}"
      end
    end

    if 'string'.respond_to?(:encode)
      def to_lf(string)
        string.encode(:universal_newline => true)
      end

      def to_crlf(string)
        string.encode(:universal_newline => true).encode(:crlf_newline => true)
      end
    else
      def to_lf(string)
        string.gsub(/\r\n?/, "\n")
      end

      def to_crlf(string)
        to_lf(string).gsub(/\n/, "\r\n")
      end
    end
  end
end
