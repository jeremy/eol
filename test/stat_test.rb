require 'test_helper'

class StatTest < EOL::Test
  before do
    @stat = EOL::Stat.new
  end
end

class StatTextTest < StatTest
  test 'text if not binary' do
    assert_equal !@stat.binary?, @stat.text?
  end
end

class StatBinaryTest < StatTest
  test 'binary if any NUL bytes' do
    assert !@stat.binary?
    @stat.nul += 1
    assert @stat.binary?
  end

  test 'binary if any bare CR' do
    assert !@stat.binary?
    @stat.cr = 1
    assert @stat.binary?
  end

  test 'binary if nonprintable/printable > 1/128' do
    assert !@stat.binary?

    @stat.nonprintable = 1
    assert @stat.binary?

    @stat.printable = 1
    assert @stat.binary?

    @stat.printable = 127
    assert @stat.binary?

    @stat.printable = 128
    assert !@stat.binary?
  end
end

class StatEOLTest < StatTest
  test 'none' do
    assert_equal :none, @stat.eol
  end

  test 'binary' do
    @stat.nul = 1
    assert_equal :binary, @stat.eol
  end

  test 'crlf' do
    @stat.crlf = 1
    assert_equal :crlf, @stat.eol
  end

  test 'lf' do
    @stat.lf = 1
    assert_equal :lf, @stat.eol
  end

  test 'mixed' do
    @stat.lf = 1
    @stat.crlf = 1
    assert_equal :mixed, @stat.eol
  end
end
