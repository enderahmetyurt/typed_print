# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "typed_print"

data = [
  { name: "Alice",   score: 98,  active: true  },
  { name: "Bob",     score: 74,  active: false },
  { name: "Charlie", score: 61,  active: true  },
  { name: "Diana",   score: 42,  active: false }
]

puts "# Basic table"
TypedPrint.print(data)
sleep 2

puts "\n# Right-align score column"
TypedPrint.print(data, align: { score: :right })
sleep 2

puts "\n# Filter columns"
TypedPrint.print(data, only: [:name, :score])
sleep 2

puts "\n# Custom headers"
TypedPrint.print(data, headers: { name: "Player", score: "Points", active: "Status" })
sleep 2

puts "\n# Markdown format"
TypedPrint.print(data, format: :markdown)
sleep 2

puts "\n# Automatic colors"
TypedPrint.print(data, color: true)
sleep 2

puts "\n# Manual colors"
TypedPrint.print(data, colors: { name: :cyan, score: :green, active: :yellow })
