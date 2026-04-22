# frozen_string_literal: true

require "typed_print/version"
require "typed_print/table"

module TypedPrint
  def self.print(data, align: {}, only: nil, headers: {}, format: :plain)
    puts table(data, align: align, only: only, headers: headers, format: format)
    nil
  end

  def self.table(data, align: {}, only: nil, headers: {}, format: :plain)
    table_obj = TypedPrint::Table.new(data, align, only, headers)
    table_obj.render(format)
  end
end
