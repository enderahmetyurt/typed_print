# frozen_string_literal: true

require "test_helper"

class TypedPrintFeaturesTest < Minitest::Test
  def test_prints_basic_table
    data = [
      { name: "Alice", score: 100, active: true },
      { name: "Bob", score: 42, active: false }
    ]

    output = capture_io do
      TypedPrint.print(data)
    end

    # Check that all headers appear
    assert_match(/Name/, output)
    assert_match(/Score/, output)
    assert_match(/Active/, output)

    # Check that data appears
    assert_match(/Alice.*100.*true/m, output)
    assert_match(/Bob.*42.*false/m, output)
  end

  def test_aligns_columns
    data = [
      { name: "Alice", score: 100 },
      { name: "Bob", score: 42 }
    ]

    output = capture_io do
      TypedPrint.print(data, align: { score: :right })
    end

    lines = output.split("\n")
    data_lines = lines[2..-1]

    # Check that score is right-aligned (numbers should be right-aligned in their column)
    assert_match(/Alice\s+100/, data_lines[0])
    assert_match(/Bob\s+42/, data_lines[1])
  end

  def test_only_specified_columns
    data = [
      { name: "Alice", score: 100, email: "alice@example.com" },
      { name: "Bob", score: 42, email: "bob@example.com" }
    ]

    output = capture_io do
      TypedPrint.print(data, only: [:name, :score])
    end

    refute_match(/email/i, output)
    assert_match(/Name.*Score/i, output)
  end

  def test_custom_headers
    data = [
      { first_name: "Alice", points: 100 },
      { first_name: "Bob", points: 42 }
    ]

    output = capture_io do
      TypedPrint.print(data, headers: { first_name: "Name", points: "Score" })
    end

    assert_match(/Name.*Score/, output)
    refute_match(/first_name/i, output)
  end

  def test_markdown_format
    data = [
      { name: "Alice", score: 100 },
      { name: "Bob", score: 42 }
    ]

    output = TypedPrint.table(data, format: :markdown)

    assert_includes output, "| Name  | Score |"
    assert_includes output, "|-------|-------|"
    assert_includes output, "| Alice | 100   |"
    assert_includes output, "| Bob   | 42    |"
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
