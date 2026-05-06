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

  def test_to_csv_returns_csv_string
    data = [{ name: "Alice", age: 30 }, { name: "Bob", age: 25 }]
    csv = TypedPrint.to_csv(data)

    assert_match(/Name,Age/, csv)
    assert_match(/Alice,30/, csv)
    assert_match(/Bob,25/, csv)
  end

  def test_to_csv_custom_delimiter
    data = [{ name: "Alice", age: 30 }]
    csv = TypedPrint.to_csv(data, delimiter: ";")

    assert_match(/Name;Age/, csv)
    assert_match(/Alice;30/, csv)
  end

  def test_to_csv_only_columns
    data = [{ name: "Alice", age: 30, city: "NY" }]
    csv = TypedPrint.to_csv(data, only: [:name, :age])

    assert_match(/Name,Age/, csv)
    refute_match(/City/, csv)
  end

  def test_to_csv_empty_data
    assert_equal "", TypedPrint.to_csv([])
  end

  def test_save_writes_file_with_bom
    data = [{ name: "Alice", score: 99 }]
    path = File.join(Dir.tmpdir, "typed_print_test_#{Process.pid}.csv")
    TypedPrint.save(data, path)

    content = File.binread(path)
    assert content.start_with?("\xEF\xBB\xBF".b), "Expected UTF-8 BOM"
    assert_match(/Name,Score/, content)
    assert_match(/Alice,99/, content)
  ensure
    File.delete(path) if File.exist?(path)
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
