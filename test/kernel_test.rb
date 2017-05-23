require 'test_helper'

class KernelTest < EOL::Test
  test 'shortcut for EOL.sniff' do
    assert_equal :lf, EOL("\n")
  end
end
