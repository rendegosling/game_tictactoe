class GameTicTacToe
  def initialize
    @board = Board.new
    setup_players
    assign_starting_player
  end
  
  def setup_players
    @player_1 = Player.new("Player 1", :x, @board)
    @player_2 = Player.new("Player 2", :o, @board)
  end

  def assign_starting_player
    @current_player = @player_1
  end

  def play
    loop do
      @board.render
      @current_player.get_coordinates
      break if game_over?
      switch_players
    end
  end

  def game_over?
    game_has_winner? || game_draw?
  end

  def game_has_winner?
    if @board.winning_combination?(@current_player.piece)
      puts "Game over...#{@current_player.name}, you win!"
      true
    else
      false
    end
  end

  def game_draw?
    if @board.full?
      puts "Game is a draw..."
      true
    else
      false
    end
  end

  def switch_players
    if @current_player == @player_1
      @current_player = @player_2
    else
      @current_player = @player_1
    end
  end
end


# player related functionality
class Player
  attr_accessor :name, :piece

  def initialize(name = "Mystery_Player", piece, board)
    raise "Piece must be a Symbol!" unless piece.is_a?(Symbol)
    @name = name
    @piece = piece
    @board = board
  end

  def get_coordinates
    loop do
      coordinates = ask_for_coordinates
      break if validate_coordinates_format(coordinates) && @board.add_piece(coordinates, @piece)
    end
  end

  def ask_for_coordinates
    puts "#{@name}(#{@piece}), enter your coordinates in x,y:"
    gets.strip.split(",").map(&:to_i)
  end

  def validate_coordinates_format(coordinates)
    if coordinates.is_a?(Array) && coordinates.size == 2
      true
    else
      puts "Your coordinates are not in the valid format!"
    end
  end
end


# responsible for the board state
class Board
  def initialize
    @board = Array.new(3){Array.new(3)}
  end

  def render
    puts
    @board.each do |row|
      row.each do |cell|
        cell.nil? ? print("-") : print(cell.to_s)
      end
      puts
    end
    puts
  end

  def add_piece(coordinates, piece)
    if piece_location_valid?(coordinates)
      @board[coordinates[0]][coordinates[1]] = piece
      true
    else
      false
    end
  end

  def piece_location_valid?(coordinates)
    if within_valid_coordinates?(coordinates)
      coordinates_available?(coordinates)
    end
  end

  def within_valid_coordinates?(coordinates)
    if (0..2).include?(coordinates[0]) && (0..2).include?(coordinates[1])
      true
    else
      puts "Piece coordinates are out of bounds"
    end
  end

  def coordinates_available?(coordinates)
    if @board[coordinates[0]][coordinates[1]].nil?
      true
    else
      puts "There is already a piece there!"
    end
  end

  def winning_combination?(piece)
    winning_diagonal?(piece)   ||
    winning_horizontal?(piece) ||
    winning_vertical?(piece)
  end

  # check if there are 3 piece in a diagonal
  def winning_diagonal?(piece)
    diagonals.any? do |diag|
      diag.all?{|cell| cell == piece }
    end
  end

  # check if there are 3 piece in a vertical
  def winning_vertical?(piece)
    verticals.any? do |vert|
      vert.all?{|cell| cell == piece }
    end
  end

  # check if there are 3 piece in a horizontal
  def winning_horizontal?(piece)
    horizontals.any? do |horizontal|
      horizontal.all?{|cell| cell == piece }
    end
  end

  def diagonals
    [[@board[0][0],@board[1][1],@board[2][2]],[@board[2][0],@board[1][1],@board[0][2]]]
  end

  def verticals
    @board
  end

  def horizontals
    horizontals = []
    3.times do |i|
      horizontals << [@board[0][i],@board[1][i],@board[2][i]]
    end
    horizontals
  end

  def full?
    @board.all? do |row|
      row.none?(&:nil?)
    end
  end
end

game = GameTicTacToe.new
game.play