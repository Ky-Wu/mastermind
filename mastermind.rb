module CodeStuff
  def code_validate(input)
    if input.length != 4
      return false
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
    code = code_array.join('')
    return code
  end
end

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
        break
      when 'codemaker'
        @game_mode = 'codemaker'
        break
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
    if guess == @code
      puts "GAME OVER! The code, #{@code}, was solved!"
      game_over
    else
      exact_correct = 0
      half_correct = 0
      duplicates = 0
      master_code = @code.split('')
      guess_array = guess.split('')
      guess_array.each_with_index do |num, index|
        if num == master_code[index]
          exact_correct += 1
        elsif @code.include?(num)
          half_correct += 1
        end
      end
      #Check for excess duplicates in the guess
      1.upto(6) do |num|
        x = num.to_s
        if guess_array.count(x) > @code.count(x) and @code.count(x) > 0
          duplicates = guess_array.count(x) - @code.count(x)
          half_correct -= duplicates
        end
      end
    end
    puts "Exactly correct positions: #{exact_correct.to_s}"
    puts "Correct digit but wrong positions: #{half_correct.to_s}"
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

end

Mastermind.new
