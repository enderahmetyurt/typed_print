# frozen_string_literal: true

require "typed_print/version"
require "typed_print/table"

require "typed_print/version"
require "typed_print/table"

module TypedPrint
  def self.print(data, align: {}, only: nil, headers: {})
    puts table(data, align: align, only: only, headers: headers)
    nil
  end

  def self.table(data, align: {}, only: nil, headers: {})
    table_obj = TypedPrint::Table.new(data, align, only, headers)
    table_obj.render
  end
end
