# Controls gameplay
class Game
  attr_reader :code_master, :code_breaker, :guess_count
  def initialize(code_master, code_breaker)
    @guess_count = 1
    @code_master = code_master
    @code_breaker = code_breaker
  end

  def play
    puts ">>>Do you want to be codemaster or codebreaker? cm/cb?"
    choice = gets.chomp
    if choice == 'cm'
      code_master.human = true
    elsif choice == 'cb'
      code_breaker.human = true
    end
    code_master.choose_code
    p code_master.code
    puts "Game start! Codemaster has chosen a code."
    puts "Color choices are: #{code_master.colors}"
    while !lose?
      guess = code_breaker.get_guess
      feedback = code_master.provide_feedback(guess)
      puts ">>>Guess ##{guess_count}: #{guess}"
      puts ">>>Feedback: #{feedback}"
      if win?(feedback)
        break
      end
      @guess_count += 1
    end
    puts game_over_message
  end

  private
  def game_over_message
    return 'CodeMaster wins!' if lose?
    return 'CodeBreaker wins!'
  end

  private
  def win?(feedback)
    feedback == ['black'] * 4
  end

  private
  def lose?
    guess_count > 12
  end

end

class CodeMaster
  attr_reader :colors, :code
  attr_writer :human
  def initialize()
    @colors = ['red', 'green', 'blue', 'yellow', 'purple', 'orange']
    @code = []
    @human = false
  end

  def choose_code
    if @human
      puts ">>>Choose your code!"
      while @code.length < 4
        puts ">>>Color ##{code.length + 1}:"
        choice = gets.chomp
        if colors.include?(choice)
          @code.push(choice)
        else
          puts "Invalid color. Options are: #{colors}"
        end
      end
      
    else
      @code = [colors.sample, colors.sample, colors.sample, colors.sample]
    end
  end

  def provide_feedback(guess)
    return ['black'] * 4 if guess == code
    feedback = []
    code_copy = code.map { |e| e }
    guess_copy = guess.map { |e| e }
    guess.each.with_index do |color, i| 
      if color == code_copy[i]
        feedback.push('black')
        code_copy[i] = ''
        guess_copy[i] = ''
      end
    end
    guess_copy.each do |color|
      if colors.include?(color) && code_copy.include?(color)
        feedback.push('white')
        code_copy[code_copy.index(color)] = ''
      end
    end
    feedback.shuffle
  end
end

class CodeBreaker
  attr_reader :colors
  attr_writer :human
  def initialize()
    @colors = ['red', 'green', 'blue', 'yellow', 'purple', 'orange']
    @human = false
  end

  def get_guess
    if @human
      guess = []
      puts '>>>Enter your guess:'
      while guess.length < 4
        puts ">>>Color ##{guess.length + 1}:"
        color = gets.chomp
        if colors.include?(color)
          guess.push(color)
        else
          puts ">>>Invalid color. The choices are: #{colors}"
        end
      end
      guess
    else
      [colors.sample, colors.sample, colors.sample, colors.sample]
    end
  end
end

cm = CodeMaster.new
cb = CodeBreaker.new()
game = Game.new(cm, cb)
game.play