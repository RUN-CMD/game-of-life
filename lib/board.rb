class Board

  attr_reader :cells, :row_count, :column_count

  def initialize(opts = {})
    opts.merge(Board.default_options).tap do |opts|
      @row_count = opts[:row_count]
      @column_count = opts[:column_count]
    end
    @cells = build_cells
  end

  def barren?
    !cells.detect {|cell| cell.alive? }
  end

  # cells are created in order by column left-to-right
  # and then row top-to-bottom
  def build_cells
    self.row_count.times do |row_index|
      self.column_count.times do |column_index|
        cells << Cell.new({
          :row_count => row_index,
          :column_count => column_index,
        })
      end
    end
  end
  private :build_cells

  def index_by_row_and_column(row_index, column_index)
    row_index * column_count + column_index
  end
  private :index_by_row_and_column

  # Advance each cell to its next iteration
  def iterate!
    cells.map(&:iterate!)
  end

  def to_s
    cells.map(&:puts)
  end

  # Iterate across the cells
  #
  # first by column, then by row,
  # with the effect of starting at the top-left
  # and going "across" and then "down".
  #
  # @param :eol
  # @param :block a block of code executed at each cell, yielding that cell
  def walk(&block)
    row_count.times do |row_index|
      column_count.times do |column_index|
        yield cells[index_by_row_and_column(row_index, column_index)]
      end
      puts "\n"
    end
  end

  private

  def self.default_options
    {
      :row_count => 20,
      :column_count => 55,
    }
  end

  class BoardWalkerAbstract
    def end_of_line
      raise MethodNotImplemented
    end
  end
end
