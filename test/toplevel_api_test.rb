require 'test_helper'
require 'stringio'

class ToplevelAPITest < EOL::Test
  test 'sniffs string' do
    assert_equal :crlf, EOL.sniff("\r\n")
  end

  test 'sniffs io' do
    assert_equal :crlf, EOL.sniff(StringIO.new("\r\n"))
  end

  test 'gets string stats' do
    assert_kind_of EOL::Stat, EOL.stat('')
  end

  test 'gets io stats' do
    assert_kind_of EOL::Stat, EOL.stat(StringIO.new(''))
  end

  test 'converts string line endings' do
    assert_equal "\n", EOL.convert("\r\n", :lf)
  end
end
