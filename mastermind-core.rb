require './mastermind-display-term.rb'
# require './mastermind-display-web.rb'

class Board

  attr_reader :gamestate, :hidden_code

  def initialize
    @board = ""
    @guesspegs = []
    @outpegs = []
    @gamestate = "ingame"
    hcode = []
    4.times do
      hcode.push(rand(1..4).to_s)
    end
    @hidden_code = hcode
    clear_board
  end

  def clear_board
    12.times do
      @guesspegs.push(['.','.','.','.'])
      @outpegs.push([])
    end
  end

  def check_move(guess, turn)
    out = []
    code_copy = self.hidden_code.clone
    guess = guess.split('')

    guess.each_index do |i|
      @guesspegs[turn][i] = guess[i]
      if guess[i] == code_copy[i]
        @outpegs[turn].push(:blackpeg)
        out.push(:blackpeg)
        code_copy[i] = '/'
        guess[i] = '!'
      end
    end

    guess.each_index do |i|
      if code_copy.any?(guess[i])
        @outpegs[turn].push(:whitepeg)
        out.push(:whitepeg)
        code_copy[code_copy.index(guess[i])] = '/'
        guess[i] = '!'
      end
    end

    out.shuffle!
    @outpegs[turn].shuffle!

    if @outpegs[turn] == [:blackpeg, :blackpeg, :blackpeg, :blackpeg]
      @gamestate = "win"
    elsif turn >= 11
      @gamestate = "lose"
    end
  end

  def get_move
    puts "Please enter a guess like this: 1234"
    gets.chomp
  end

  def guesspegs
    outmsg = ""
    12.times do |i|
      outmsg += @guesspegs[i].join + "<br>"
    end
    outmsg
  end

  def display_board
    outmsg = ""
    12.times do |i|
      outmsg += @guesspegs[i].join + '|' + @outpegs[i].join + "<br>"
    end
    outmsg
  end

  def display_board_web
    outmsg = ""
    12.times do |i|
      outmsg += @guesspegs[i].join + '|'
      @outpegs[i].each do |item|
        outmsg += "<img src='" + item.to_s  + ".svg' />"
        p outmsg
      end
      outmsg += "<br>"
    end
    outmsg
  end

end

class Game
  attr_accessor :board, :display_term

  def initialize
    @master = nil
    @guesser = nil
    new_game
  end


  def main_menu
    choice = ''
    while true do
      puts "Welcome to MASTERMIND! Please select an option:"
      puts "(N)ew Game"
      puts "(Q)uit"
      choice = gets.chomp
      !"qQnN".include?(choice) ? next : break
    end
  
    case choice.downcase
    when 'q'
      exit
    when 'n'
      return 'start'
    end
  end

  def new_game_2(master, guesser)
  end


  def new_game
    puts "-"*10

    puts "Mastermind: (H)uman or (C)omputer?"
    master_choice = gets.chomp
    while !"hHcC".include?(master_choice) do
      puts "Mastermind: (H)uman or (C)omputer?"
      master_choice = gets.chomp
    end

    case master_choice.downcase
    when 'h'
      @master = HumanPlayer.new  
    when 'c'
      @master = ComputerPlayer.new
    end

    puts "Guesser: (H)uman or (C)omputer?"
    guesser_choice = gets.chomp
    while !"hHcC".include?(master_choice) do
      puts "Guesser: (H)uman or (C)omputer?"
      guesser_choice = gets.chomp
    end
    
    case guesser_choice.downcase
    when 'h'
      @guesser = HumanPlayer.new
    when 'c'
      @guesser = ComputerPlayer.new
    end


    self.display_term = Display_Term.new
    self.board = Board.new
    self.board.hidden_code = @master.get_hidden_code

    12.times do |i|
      self.display_term.display_board(self.board.guesspegs, self.board.outpegs)
      result = self.board.check_move(@guesser.get_guess, i)
      if result == 'win'
        self.display_term.display_board(self.board.guesspegs, self.board.outpegs)
        puts self.display_term.end_message(:win, self.board.hidden_code)
        exit
      end
    end
    puts self.display_term.end_message(:lose, self.board.hidden_code)
  end
end

class Player
  attr_writer :last_peg_result
  
  def get_hidden_code
  end

  def get_guess
  end
end


class HumanPlayer < Player

  def get_hidden_code
    puts "Please enter 4 random numbers, each from 1-4. Like this: 2314"
    puts "Don't show the guesser!"
    gets.chomp.split('')
  end

  def get_guess
    puts "Please enter a guess, like this: 1234"
    gets.chomp
  end
end

class ComputerPlayer < Player

  def get_hidden_code
    hidden_code = []
    4.times do
      hidden_code.push(rand(1..4).to_s)
    end
    hidden_code
  end

  def get_guess
    guess = ""
    4.times do
      guess += rand(1..4).to_s
    end
    gets
    guess
  end

end

if __FILE__ == 'mastermind-core.rb'
  g = Game.new
  while true do
    g.main_menu
    g.new_game
  end
end
