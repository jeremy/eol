require 'test_helper'
require 'stringio'

class ConverterTest < EOL::Test
  test 'binary string' do
    assert_raises RuntimeError do
      EOL::Converter.convert("\x7F", :lf)
    end

    assert_raises RuntimeError do
      EOL::Converter.convert("\r", :lf)
    end
  end

  test 'requesting unknown line ending' do
    assert_raises ArgumentError do
      EOL::Converter.convert("\n", :foo)
    end
  end

  test 'to LF' do
    assert_equal "\n", EOL::Converter.convert("\n", :lf)
    assert_equal "\n", EOL::Converter.convert("\r\n", :lf)
    assert_equal "\n\n", EOL::Converter.convert("\r\n\n", :lf)
  end

  test 'to CRLF' do
    assert_equal "\r\n", EOL::Converter.convert("\n", :crlf)
    assert_equal "\r\n", EOL::Converter.convert("\r\n", :crlf)
    assert_equal "\r\n\r\n", EOL::Converter.convert("\r\n\n", :crlf)
  end
end
