require "terminal-table"

module PulseAnalysis

  module Console

    class Table

      attr_reader :content

      def self.build(report)
        table = new(report)
        table.build
        table
      end

      def initialize(report)
        @report = report
      end

      def build
        headings = [
          "Item",
          {
            value: "Value",
            colspan: value_colspan
          }
        ]
        @content = Terminal::Table.new(title: "Pulse Analysis", headings: headings) do |table|
          @report.items.each { |item| table << build_row(item) }
        end
      end

      private

      def value_colspan
        @value_colspan ||= @report.items.map { |item| item[:value] }.map(&:count).max
      end

      def build_row(item)
        row = [item[:description]]
        if item[:value].kind_of?(Array)
          # item has multiple units of measure
          item[:value].each_with_index do |value, i|
            cell = {
              value: "#{value[:value]} (#{value[:unit]})",
            }
            # make up remaining colspan
            if item[:value].last == value
              cell[:colspan] = value_colspan - i
            end
            row << cell
          end
        else
          # item has single unit of measure
          value = item[:value]
          row << {
            value: "#{value[:value]} (#{value[:unit]})",
            colspan: value_colspan # full width
          }
        end
        row
      end

    end

  end

end
