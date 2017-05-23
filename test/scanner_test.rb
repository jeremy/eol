require 'test_helper'
require 'stringio'

class ScannerTest < EOL::Test
  before do
    @scanner = EOL::Scanner.new
  end

  test 'scans io' do
    assert_kind_of EOL::Stat, @scanner.scan(StringIO.new(''))
  end

  test 'scans string' do
    assert_kind_of EOL::Stat, @scanner.scan('')
  end

  test 'accumulates stats' do
    assert_equal 1, @scanner.scan("\n").lf
    assert_equal 2, @scanner.scan("\n").lf
  end

  test 'CR' do
    assert_equal 1, @scanner.scan("\r").cr
  end

  test 'LF' do
    assert_equal 1, @scanner.scan("\n").lf
  end

  test 'CRLF' do
    stat = @scanner.scan("\r\n")
    assert_equal 1, stat.crlf
    assert_equal 0, stat.cr
    assert_equal 0, stat.lf
  end

  test 'DEL nonprintable' do
    assert_equal 1, @scanner.scan("\x7F").nonprintable
  end

  test 'NUL nonprintable' do
    stat = @scanner.scan("\x00")
    assert_equal 1, stat.nul
    assert_equal 1, stat.nonprintable
  end

  test 'BS printable' do
    assert_equal 1, @scanner.scan("\b").printable
  end

  test 'HT printable' do
    assert_equal 1, @scanner.scan("\t").printable
  end

  test 'FF printable' do
    assert_equal 1, @scanner.scan("\f").printable
  end

  test 'ESC printable' do
    assert_equal 1, @scanner.scan("\e").printable
  end

  ((0...32).to_a - [0, 8, 9, 10, 12, 13, 26, 27]).each do |ord|
    test "0x#{ord} nonprintable control char" do
      assert_equal 1, @scanner.scan(ord.chr).nonprintable
    end
  end

  test 'non-trailing EOF treated as nonprintable' do
    stat = @scanner.scan("\x1A ")
    assert_equal 1, stat.printable
    assert_equal 1, stat.nonprintable
  end

  test 'trailing EOF not treated as nonprintable' do
    stat = @scanner.scan(" \x1A")
    assert_equal 1, stat.printable
    assert_equal 0, stat.nonprintable
  end
end
