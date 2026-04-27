# TypedPrint

Beautiful, aligned table output for Ruby hashes and objects with zero dependencies.

[![Gem Version](https://badge.fury.io/rb/typed_print.svg)](https://badge.fury.io/rb/typed_print)
[![Ruby](https://github.com/enderahmetyurt/typed_print/actions/workflows/main.yml/badge.svg)](https://github.com/enderahmetyurt/typed_print/actions/workflows/main.yml)
[![Ruby Version](https://img.shields.io/badge/ruby->=%202.6-blue.svg)](https://www.ruby-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Gem Downloads](https://img.shields.io/gem/dt/typed_print)](https://rubygems.org/gems/typed_print)

![TypedPrint Demo](assets/demo.gif)

## Features

- 🚀 Zero runtime dependencies
- 📊 Automatic column width calculation
- 🎯 Smart type formatting (booleans, nil, strings)
- 📐 Column alignment (left, right, center)
- 🎨 Custom column headers
- 🔍 Column filtering
- 📝 Preserves original column order
- 📄 Markdown table output (v0.2.0+)
- 🌈 Optional color output via `pastel` gem (v0.3.0+)

## Installation

Add this line to your application's Gemfile:

`gem 'typed_print'`

Or install it yourself:

`gem install typed_print`

## Usage

### Basic Usage

```ruby
require 'typed_print'

data = [
  { name: "Alice", score: 100, active: true },
  { name: "Bob", score: 42, active: false }
]

TypedPrint.print(data)
```

Output:

```
Name  Score Active 
------+------+-------
Alice   100 true   
Bob      42 false  
```

### Markdown Format (NEW in v0.2.0)
```ruby
TypedPrint.print(data, format: :markdown)
```

Output:
```
| Name  | Score | Active |
|-------|-------|--------|
| Alice | 100   | true   |
| Bob   | 42    | false  |
```

### Column Alignment
```ruby
TypedPrint.print(data, align: { score: :right })
```

Output:
```
Name  Score Active 
------+------+-------
Alice   100 true   
Bob      42 false
```

### Filter Columns

```ruby
TypedPrint.print(data, only: [:name, :score])
```

Output:
```
Name  Score 
------+------
Alice   100 
Bob      42 
```

### Custom Headers
```ruby
TypedPrint.print(data, headers: { name: "Username", score: "Points", active: "Status" })
```

Output:
```
Username Points Status 
---------+------+-------
Alice       100 true   
Bob          42 false  
```

### Return String Instead of Printing
```ruby
table_string = TypedPrint.table(data)
puts table_string.upcase

# Markdown format
markdown_string = TypedPrint.table(data, format: :markdown)
File.write("table.md", markdown_string)
````

### Working with Different Data Types
```ruby
mixed_data = [
  { name: "Product A", price: 29.99, in_stock: true, notes: nil },
  { name: "Product B", price: 49.99, in_stock: false, notes: "Limited edition" }
]

TypedPrint.print(mixed_data)
```

Output:
```
Name      Price In_stock Notes        
----------+-------+---------+-------------
Product A   29.99 true                  
Product B   49.99 false    Limited edition
```

## API Reference
`TypedPrint.print(data, options)` Prints the formatted table to stdout and returns `nil`.


**Options:**
- `align: Hash` - Column alignment (`:left`, `:right`, `:center`), defaults to `:left`
- `only: Array` - Array of column symbols to display
- `headers: Hash` - Custom headers for columns
- `format: Symbol` - Output format (`:plain` or `:markdown`), defaults to `:plain`
- `color: Boolean` - Auto color by type (headers cyan, numbers/true green, false red, nil gray), requires `pastel` gem
- `colors: Hash` - Manual per-column color map (e.g. `{ name: :cyan, score: :green }`), requires `pastel` gem

`TypedPrint.table(data, options)` returns the formatted table as a string.

Same options as `print`.

### Color Output (v0.3.0+)

Color support is optional and requires the `pastel` gem. Add it to your Gemfile:

```ruby
gem 'pastel'
```

**Automatic coloring by type:**
```ruby
TypedPrint.print(data, color: true)
# Headers → cyan, Integer/Float/true → green, false → red, nil → gray
```

**Manual per-column colors:**
```ruby
TypedPrint.print(data, colors: { name: :cyan, score: :green, active: :yellow })
```

Both `:plain` and `:markdown` formats support color. If `pastel` is not installed, color options are silently ignored and output is plain text.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/typed_print.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
