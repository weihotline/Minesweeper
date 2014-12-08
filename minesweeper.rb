require 'yaml'
require './tile.rb'
require './board.rb'
require './leaderboard.rb'

module Minesweeper
  class GamePlay

    def initialize
      @board = Board.new
      @scoreboard = Leaderboard.new
    end

    def display_board
      p @board
    end

    def play
      start_time = Time.now
      until @board.over?
        display_board
        get_input
      end

      if @board.lost?
        puts "Game Over! You are bombed!!"
      else
        puts "You won!!"
        elapsed_time = Time.now - start_time
            puts "Type your name: "
            name = gets.chomp
            @scoreboard.scores[name] = elapsed_time
            @scoreboard.record_score
      end

        p @scoreboard

    end

    def save
      File.open("saved-game", "w") do |f|
        saved_game = self.to_yaml
        f.puts saved_game
      end
    end

    def get_input
      puts "Enter a coordinate: x,y"
      pos = gets.chomp.upcase
      return save if pos == "SAVE"
      exit if pos == "QUIT"

      pos = pos.split(",").map { |i| i.to_i }

      puts "Reveal or flag? R/F"
      move = gets.chomp.upcase
      if move == "R"
        @board[pos].reveal
      elsif move == "F"
        @board[pos].flag
      else
        puts "Invalid input!"
      end
    end

  end
end

#

puts "Welcome to Minesweeper! New game or load saved? N/S"
ans = gets.chomp.upcase
if ans == "S"
  yaml_minesweeper = File.read("saved-game")
  minesweeper = YAML::load(yaml_minesweeper)
else
  minesweeper = Minesweeper::GamePlay.new
end

minesweeper.play