module Minesweeper

  class Tile
    NEIGHBOR_OFFSETS = [
        [0,1],
        [1,0],
        [0,-1],
        [-1,0],
        [-1,-1],
        [-1,1],
        [1, -1],
        [1,1]
    ]
    attr_accessor :position, :bombed, :revealed, :value

    def initialize(board, bombed = false)
      @bombed = bombed
      @board = board
      @revealed = false
      @flagged = false
      @position = nil
      @value = 0
    end

    def bombed?
      @bombed
    end

    def flagged?
      @flagged
    end

    def flag
     @flagged = (@flagged ? false : true)
    end

    def revealed?
      @revealed
    end

    def reveal
      self.revealed = true
      self.value = self.neighbor_bomb_count
      adjacent_tiles = neighbors
      adjacent_tiles.each do |tile|
        next if tile.revealed? || tile.bombed? || tile.flagged?
        tile.revealed = true
        tile.value = tile.neighbor_bomb_count
        tile.reveal if tile.value == 0
      end
    end

    def neighbors
      all_neighbors = []

      NEIGHBOR_OFFSETS.each do |pos|
        x, y = @position[0], @position[1]
        all_neighbors << [x + pos[0], y + pos[1]]
      end

      all_neighbors.select! do |pos|
        pos[0].between?(0, 8) && pos[1].between?(0, 8)
      end

      all_neighbors.map! {|pos| @board[pos] }
    end

    def neighbor_bomb_count
      bomb_counter = 0

      adjacent_tiles = self.neighbors
      adjacent_tiles.each do |tile|
        bomb_counter += 1 if tile.bombed?
      end

      bomb_counter
    end

    def inspect
      if flagged?
        "F"
      elsif revealed?
        if value == 0
          "_"
        else
          value
        end
      else
        "*"
      end
    end
  end
end
