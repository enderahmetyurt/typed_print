# frozen_string_literal: true

module TypedPrint
  class Table
    def initialize(data, alignments = {}, only_columns = nil, custom_headers = {})
      @data = data
      @alignments = alignments
      @only_columns = only_columns&.map(&:to_sym)
      @custom_headers = custom_headers.transform_keys(&:to_sym)

      @headers = determine_headers
    end

    def render(format = :plain)
      if format == :markdown
        render_markdown
      else
        render_plain
      end
    end

    def render_plain
      return "" if @data.empty?

      # Build rows
      rows = @data.map { |row| @headers.map { |h| format_value(row[h]) } }

      # Build header strings (with custom headers or capitalized defaults)
      header_strings = @headers.map do |h|
        if @custom_headers[h]
          @custom_headers[h]
        else
          h.to_s.split('_').map(&:capitalize).join(' ')
        end
      end

      # Calculate column widths
      column_widths = header_strings.map(&:length)
      rows.each do |row|
        row.each_with_index do |cell, i|
          column_widths[i] = [column_widths[i], cell.length].max
        end
      end

      # Build output
      output = []
      output << format_row(header_strings, column_widths, :center)
      output << separator(column_widths)
      rows.each do |row|
        output << format_row(row, column_widths)
      end

      output.join("\n")
    end

    def render_markdown
      return "" if @data.empty?

      # Build rows
      rows = @data.map { |row| @headers.map { |h| format_value(row[h]) } }

      # Build header strings
      header_strings = @headers.map do |h|
        if @custom_headers[h]
          @custom_headers[h]
        else
          h.to_s.split('_').map(&:capitalize).join(' ')
        end
      end

      # Calculate column widths for consistent spacing
      column_widths = header_strings.map(&:length)
      rows.each do |row|
        row.each_with_index do |cell, i|
          column_widths[i] = [column_widths[i], cell.length].max
        end
      end

      # Build markdown table
      output = []
      # Header row
      output << "| " + header_strings.each_with_index.map { |h, i| h.ljust(column_widths[i]) }.join(" | ") + " |"
      # Separator row
      output << "|" + column_widths.map { |w| "-" * (w + 2) }.join("|") + "|"
      # Data rows
      rows.each do |row|
        output << "| " + row.each_with_index.map { |cell, i| cell.ljust(column_widths[i]) }.join(" | ") + " |"
      end

      output.join("\n")
    end

    private

    def format_value(value)
      case value
      when true then "true"
      when false then "false"
      when nil then ""
      else value.to_s
      end
    end

    def determine_headers
      all_keys = @data.flat_map(&:keys).uniq

      if @only_columns
        @only_columns.select { |key| all_keys.include?(key) }
      else
        first_item_keys = @data.first.keys
        first_item_keys + (all_keys - first_item_keys)
      end
    end

    def format_row(cells, widths, alignment_override = nil)
      cells.each_with_index.map do |cell, i|
        width = widths[i]
        header_key = @headers[i]

        align = if alignment_override
          alignment_override
        elsif @alignments[header_key]
          @alignments[header_key]
        else
          :left
        end

        case align
        when :right
          cell.rjust(width)
        when :center
          cell.center(width)
        else
          cell.ljust(width)
        end
      end.join(" ")
    end

    def separator(widths)
      widths.map { |w| "-" * w }.join("-+-")
    end
  end
end
