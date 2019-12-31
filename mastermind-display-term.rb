class Display_Term
  RED = "\033[1;31;40m"
  BLUE = "\033[1;34;40m"
  GREEN = "\033[1;32;40m"
  YELLOW = "\033[1;33;40m"
  BLACK = "\033[1;30;40m"
  WHITE = "\033[1;37;40m"
  COLOROFF = "\033[0m"

  BG = BLACK + " " + COLOROFF
  GUESSDOT = "\u25C9"
  BLACKPEG = BLACK + GUESSDOT + COLOROFF
  WHITEPEG = WHITE + GUESSDOT + COLOROFF 

  BGROW = (BG*80)

  def initialize
    @term_constants = {
      blackpeg: BLACKPEG,
      whitepeg: WHITEPEG }
  end

  def display_board(board, outpegs)
    out = ""
    out += "\n----\n"
    board.each_with_index do |row, ind|
      out += row.join("")
      out += "|"
      outpegs[ind].size.times { |i| out += @term_constants[outpegs[ind][i]] }
      out += "\n"
    end
    out += "----\n????"
    puts out
  end

  def get_color_dot(char)
    color = BLACK
    case char
    when 'r'
      color = RED
    when 'b'
      color = BLUE
    when 'g'
      color = GREEN
    when 'y'
      color = YELLOW
    when '.'
      color = BLACK
    end
    return color + GUESSDOT + COLOROFF
  end

  def end_message(result, hidden_code)
    outmsgs = {
      win: "You win! The correct code was: #{hidden_code}",
      lose: "Sorry, out of turns :[ The correct code was: #{hidden_code}"
    }
    outmsgs[result]
  end
end
