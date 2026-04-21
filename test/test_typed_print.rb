# frozen_string_literal: true

require "test_helper"

class TestTypedPrint < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TypedPrint::VERSION
  end

  def test_it_prints_a_simple_table
    data = [{ name: "Test", value: 123 }]

    output = capture_io do
      TypedPrint.print(data)
    end

    assert_match(/Name.*Value/, output)
    assert_match(/Test.*123/, output)
  end

  private

  def capture_io
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
end
