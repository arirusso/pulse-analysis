require "terminal-table"

module PulseAnalysis

  module Console

    class Table

      attr_reader :content

      # @param [PulseAnalysis::Report] report
      # @return [PulseAnalysis::Console::Table]
      def self.build(report)
        table = new(report)
        table.build
        table
      end

      # @param [PulseAnalysis::Report] report
      def initialize(report)
        @report = report
      end

      # Populate the table content
      # @return [Terminal::Table]
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

      # How many columns should the 'value' row be?
      # @return [Integer]
      def value_colspan
        @value_colspan ||= @report.items.map { |item| item[:value] }.map(&:count).max
      end

      # Build a single table row with the given report item
      # @param [Hash] item
      # @return [Array<String>]
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
