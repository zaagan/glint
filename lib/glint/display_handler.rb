
module Glint
  module DisplayHandler
  
    def print_rows(rows, search_type = nil, options = {})
      table_rows = rows.map do |row|
        type = row[0]

        if search_type
          name = row[1]
        else
          name = row[1].colorize(:light_blue).bold
        end

        code = row[2].colorize(:light_green)
        description = row[3]

        new_row = []
        new_row << type if search_type.nil?
        new_row.concat([name, code])
        new_row << description if options['description']

        new_row
      end

      headings = []
      headings << 'Type' if search_type.nil?
      headings += ['Name', 'Code']
      headings << 'Description' if options['description']

      title = "#{search_type} Cheat Sheet" if search_type

      table = Terminal::Table.new(
        title: title,
        headings: headings,
        rows: table_rows,
        style: {
          border_x: '',
          border_i: '',
          border_y: '',
          padding_left: 0,
          padding_right: 2
        }
      )
      table.align_column(0, :left)
      table.align_column(1, :left)
      table.align_column(2, :left)
      table.align_column(3, :left)

      puts table
    end

  end

end