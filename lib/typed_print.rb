# frozen_string_literal: true

require "typed_print/version"
require "typed_print/table"

module TypedPrint
  def self.print(data, align: {}, only: nil, headers: {}, format: :plain, color: false, colors: nil)
    puts table(data, align: align, only: only, headers: headers, format: format, color: color, colors: colors)
    nil
  end

  def self.table(data, align: {}, only: nil, headers: {}, format: :plain, color: false, colors: nil)
    table_obj = TypedPrint::Table.new(data, align, only, headers, color: color, colors: colors)
    table_obj.render(format)
  end

  def self.to_csv(data, only: nil, headers: {}, delimiter: ",")
    table_obj = TypedPrint::Table.new(data, {}, only, headers)
    table_obj.to_csv(col_sep: delimiter)
  end

  def self.save(data, path, only: nil, headers: {}, delimiter: ",")
    csv = to_csv(data, only: only, headers: headers, delimiter: delimiter)
    File.write(path, "\xEF\xBB\xBF" + csv, encoding: "UTF-8")
    nil
  end
end
