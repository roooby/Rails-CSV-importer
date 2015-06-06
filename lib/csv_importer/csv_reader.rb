module CSVImporter

  # Reads, sanitize and parse a CSV file
  class CSVReader
    include Virtus.model

    attribute :content, String
    attribute :file # IO
    attribute :path, String

    def csv_rows
      @csv_rows ||= sanitize_cells(CSV.parse(sanitize_content(read_content)))
    end

    # Returns the header as an Array of Strings
    def header
      @header ||= csv_rows.first
    end

    # Returns the rows as an Array of Arrays of Strings
    def rows
      @rows ||= csv_rows[1..-1]
    end

    private

    def read_content
      if content
        content
      elsif file
        file.read
      elsif path
        File.open(path).read
      else
        raise Error, "Please provide content, file, or path"
      end
    end

    # Strip cells
    def sanitize_cells(rows)
      rows.map do |cells|
        cells.map do |cell|
          cell.strip if cell
        end
      end
    end

    def sanitize_content(csv_content)
      csv_content.
        scrub(''). # Remove invalid byte sequences
        gsub(/\r\r?\n?/, "\n") # Replaces windows line separators with "\n"
    end
  end
end
