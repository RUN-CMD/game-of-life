class Game
  def run
    board = Board.new
    while !board.barren?
      board.iterate!
      puts board
    end
  end
end
