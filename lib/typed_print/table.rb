# frozen_string_literal: true

begin
  require "pastel"
rescue LoadError
  # Pastel not installed; color output silently disabled
end

module TypedPrint
  class Table
    def initialize(data, alignments = {}, only_columns = nil, custom_headers = {}, color: false, colors: nil)
      @data = data
      @alignments = alignments
      @only_columns = only_columns&.map(&:to_sym)
      @custom_headers = custom_headers.transform_keys(&:to_sym)
      @color_auto = color
      @colors = colors&.transform_keys(&:to_sym)

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

      rows_plain = @data.map { |row| @headers.map { |h| format_value(row[h]) } }
      header_strings_plain = @headers.map { |h| header_label(h) }

      column_widths = header_strings_plain.map(&:length)
      rows_plain.each do |row|
        row.each_with_index do |cell, i|
          column_widths[i] = [column_widths[i], cell.length].max
        end
      end

      if color_mode?
        header_color = @color_auto ? :cyan : nil
        header_strings_display = header_strings_plain.map { |h| colorize(h, header_color) }
        rows_display = @data.map { |row| @headers.map { |h| colorize_cell(h, row[h]) } }
      else
        header_strings_display = header_strings_plain
        rows_display = rows_plain
      end

      output = []
      output << format_row(header_strings_display, column_widths, :center, header_strings_plain)
      output << separator(column_widths)
      rows_plain.each_with_index do |plain_row, ri|
        output << format_row(rows_display[ri], column_widths, nil, plain_row)
      end

      output.join("\n")
    end

    def render_markdown
      return "" if @data.empty?

      rows_plain = @data.map { |row| @headers.map { |h| format_value(row[h]) } }
      header_strings_plain = @headers.map { |h| header_label(h) }

      column_widths = header_strings_plain.map(&:length)
      rows_plain.each do |row|
        row.each_with_index do |cell, i|
          column_widths[i] = [column_widths[i], cell.length].max
        end
      end

      if color_mode?
        header_color = @color_auto ? :cyan : nil
        header_strings_display = header_strings_plain.map { |h| colorize(h, header_color) }
        rows_display = @data.map { |row| @headers.map { |h| colorize_cell(h, row[h]) } }
      else
        header_strings_display = header_strings_plain
        rows_display = rows_plain
      end

      output = []
      output << "| " + header_strings_display.each_with_index.map { |h, i|
        pad_right(h, header_strings_plain[i], column_widths[i])
      }.join(" | ") + " |"
      output << "|" + column_widths.map { |w| "-" * (w + 2) }.join("|") + "|"
      rows_plain.each_with_index do |plain_row, ri|
        output << "| " + rows_display[ri].each_with_index.map { |cell, i|
          pad_right(cell, plain_row[i], column_widths[i])
        }.join(" | ") + " |"
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

    def header_label(h)
      if @custom_headers[h]
        @custom_headers[h]
      else
        h.to_s.split("_").map(&:capitalize).join(" ")
      end
    end

    def color_mode?
      @color_auto || (@colors && !@colors.empty?)
    end

    def colorize(text, color)
      return text unless color && defined?(Pastel)
      @pastel ||= Pastel.new
      @pastel.send(color, text)
    rescue
      text
    end

    def colorize_cell(header_key, original_value)
      plain = format_value(original_value)
      color = cell_color(header_key, original_value)
      colorize(plain, color)
    end

    def cell_color(header_key, value)
      if @colors
        @colors[header_key]
      elsif @color_auto
        auto_color(value)
      end
    end

    def auto_color(value)
      case value
      when Integer, Float then :green
      when true then :green
      when false then :red
      when nil then :bright_black
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

    def format_row(cells, widths, alignment_override = nil, plain_cells = nil)
      cells.each_with_index.map do |cell, i|
        plain_cell = plain_cells ? plain_cells[i] : cell
        width = widths[i]
        header_key = @headers[i]

        align = if alignment_override
          alignment_override
        elsif @alignments[header_key]
          @alignments[header_key]
        else
          :left
        end

        padding = width - plain_cell.length

        case align
        when :right
          " " * padding + cell
        when :center
          left_pad = padding / 2
          right_pad = padding - left_pad
          " " * left_pad + cell + " " * right_pad
        else
          cell + " " * padding
        end
      end.join(" ")
    end

    def pad_right(colored_text, plain_text, width)
      colored_text + " " * (width - plain_text.length)
    end

    def separator(widths)
      widths.map { |w| "-" * w }.join("-+-")
    end
  end
end
