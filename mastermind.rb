class Mastermind
  attr_accessor :game_mode, :code, :countdown
  include CodeStuff
  def initialize
    @countdown = 12
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
    create_code
  end

  def create_code
    @code ||= Code.new(@game_mode).code
    if @game_mode == 'guesser'
      puts "Remember, in 12 turns, you have to guess a code consisting of 4 digits, each from 1-6."
      player_guesser
    else #when game_mode is codemaker
      puts "Your code is: #{@code}"
      computer_guesser
    end
  end

  def player_guesser
    puts "#{@countdown} guesses remaining."
    puts "Enter your guess now:"
    while guess = gets.chomp.downcase
      if code_validate(guess)
        code_check(guess)
      else
        puts "That's not a valid code! It has to be 4 digits long, each from 1-6!"
      end
    end
  end

  def code_check(guess)
    exact_correct = 0
    half_correct = 0
    duplicates = 0
    master_code = @code.split('')
    guess_array = guess.split('')
    if master_code == guess_array
      puts "GAME OVER! The code, #{@code}, was solved!"
      game_over
    else
      guess_array.each do |num|
        duplicates_counted = false
        current_index = guess_array.index(num)
        if num == master_code[current_index]
          exact_correct += 1
        elsif guess.count(num) <= @code.count(num)
          half_correct += 1
        elsif guess.count(num) > @code.count(num)
          unless duplicates_counted
            duplicates = guess.count(num) - @code.count(num)
            #This iteration includes the current digit, hence the -1 tacked on
            half_correct -= duplicates - 1
            duplicates_counted = true
          else
            half_correct += 1
          end
        end
      end
    end
    puts "Exactly correct: #{exact_correct.to_s}"
    puts "Correct digit but wrong position: #{half_correct.to_s}"
    @countdown -= 1
    if @countdown == 0
      puts "GAME OVER! The bomb exploded! Guess you'll never find out what the code was..."
      game_over
    else
      player_guesser
    end
  end

  def game_over
    puts "Do you want to start a new game? [Yes/No]"
    while choice = gets.chomp.downcase
      case choice
      when 'yes'
        Mastermind.new
        break
      when 'no'
        puts "Well this is it then. Nice knowing you, pal. See ya around."
        break
      else
        puts "Please pick 'Yes' or 'No.'"
      end
    end
  end

end

class Code
  include CodeStuff
  attr_accessor :code, :type
  def initialize(type)
    case type
    when 'guesser'
      @code = generate_code
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
end

module CodeStuff
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

  def generate_code
    code_array = []
    4.times { code_array.push(rand(1..6).to_s) }
    return code_array.join('')
  end
end
