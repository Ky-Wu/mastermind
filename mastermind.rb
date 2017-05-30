class Mastermind
  attr_accessor :game_mode, :code,
  def initialize
    puts "Welcome to Mastermind."
    puts "Please choose a gamemode. Guesser or Codemaker?"
    while game_mode = gets.chomp.downcase
      case game_mode
      when 'guesser'
        @game_mode = 'guesser'
      when 'codemaker'
        @game_mode = 'codemaker'
      else
        puts "Select a valid gamemode: Guesser or Codemaker."
      end
    end
    display
  end

  def display
    if @game_mode == 'guesser'
    else #when game_mode is codemaker
      @code ||= Code.new(@game_mode).code
      puts "Your code is: #{@code}"
    end

end

class Code
  attr_accessor :code, :type
  def initialize(type)
    case type
    when 'guesser'
      generate_code
    when 'codemaker'
      codemaker
    end
  end

  def codemaker
    puts "Please input your code now. Remember, the AI will try to guess the code, which
    must consist of four digits from 1-6."
    while code = gets.chomp
      if code_validate(code)
        @code = code
      else
        puts "Enter a valid code! Remember, it must be 6 digits, each from 1-6."
    end
  end

  def code_validate(input)
    if input.length != 4
      return validity
    end
    ['0','7','8','9'].each do |num|
      if input.include?(num)
        return false
      end
    end
    true
  end
end
