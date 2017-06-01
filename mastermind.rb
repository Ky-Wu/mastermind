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
  attr_accessor :game_mode, :code, :countdown, :game_over, :cheats, :combinations
  include CodeStuff
  def initialize
    @game_over = false
    # Will be used in computer_guesser
    @combinations = []
    1.upto(6) do |num1|
      1.upto(6) do |num2|
        1.upto(6) do |num3|
          1.upto(6) do |num4|
            possibility = num1.to_s + num2.to_s + num3.to_s + num4.to_s
            @combinations << possibility
          end
        end
      end
    end
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
    puts "\n#{@countdown} guesses remaining."
    if guess == @code
      puts "GAME OVER! The code, #{@code}, was solved!"
      game_end
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
      game_end
    elsif @game_mode == 'guesser'
      player_guesser
    else
      return [exact_correct, half_correct]
    end
  end

  def code_tester(guess, possible_answer)
    exact_correct = 0
    half_correct = 0
    duplicates = 0
    master_code = possible_answer.split('')
    guess_array = guess.split('')
    guess_array.each_with_index do |num, index|
      if num == master_code[index]
        exact_correct += 1
      elsif possible_answer.include?(num)
        half_correct += 1
      end
    end
    #Check for excess duplicates in the guess
    1.upto(6) do |num|
      x = num.to_s
      if guess_array.count(x) > possible_answer.count(x) and possible_answer.count(x) > 0
        duplicates = guess_array.count(x) - possible_answer.count(x)
        half_correct -= duplicates
      end
    end
    [exact_correct, half_correct]
  end


  def computer_guesser
    guess = @combinations.sample
    compare = code_check(guess)
    puts "GUESS: #{guess}"
    @combinations.delete_if do |combo|
      code_tester(guess, combo) != compare
    end
    unless @game_over
      computer_guesser
    end

  end

  def game_end
    @game_over = true
    puts "Do you want to start a new game? [Yes/No]"
    while choice = gets.chomp.downcase
      case choice
      when 'yes'
        Mastermind.new
        break
      when 'no'
        puts "Well this is it then. Nice knowing you, pal. See ya around."
        exit
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
        break
      else
        puts "Enter a valid code! Remember, it must be 6 digits, each from 1-6."
      end
    end
  end

end

Mastermind.new
