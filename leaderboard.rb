require 'json'

module Minesweeper
  class Leaderboard
    attr_accessor :scores

    def initialize
      @scores = self.read_leaderboard
    end

    def record_score
      File.open("leaderboard.json", "w") do |f|
        leaderboard = @scores.to_json
        f.puts leaderboard
      end
    end

    def read_leaderboard
      File.open("leaderboard.json", "r") do |f|
        json_scores = f.gets.chomp
        @scores = JSON.parse(json_scores)
      end
    end

    def inspect
      sorted_scores = @scores.sort_by  {|key, value| value}
      p "Hight scores: "
      5.times do |i|
        puts "#{sorted_scores[i][0]}: #{sorted_scores[i][1]}"
      end
      nil
    end

  end
end