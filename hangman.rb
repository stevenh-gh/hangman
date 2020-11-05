require_relative 'sample'

class Hangman
  attr_accessor :dict, :sample, :amt_guesses, :word, :guessed_right, :guessed_wrong

  def initialize
    @dict = load_dictionary
    @sample = Sample.new dict
    @amt_guesses = 6 # Stick figure takes 6 marks to complete
    @word = Array.new sample.random_word.length, '_'
    @guessed_right = []
    @guessed_wrong = []
  end

  def play
    display_word_guess word, amt_guesses
    separator
    loop do
      guess = query_player(guessed_right + guessed_wrong)

      if sample.random_word.downcase.include? guess
        word.map!.with_index { |ele, idx| sample.random_word[idx].downcase == guess ? sample.random_word[idx] : ele }
        guessed_right << guess
      else
        self.amt_guesses -= 1
        guessed_wrong << guess
      end

      display_word_guess word, amt_guesses

      print_guesses

      if amt_guesses == 0
        puts 'You have failed to guess the word!'
        puts "The word is: #{sample.random_word}"
        break
      end

      if word.join('') == sample.random_word
        puts 'You have guessed the word correctly!'
        break
      end
    end
  end

  private

  def load_dictionary
    File.readlines('5desk.txt').map { |row| row.chomp }
  end

  def display_word_guess(word, amt_guesses)
    puts "Amount of guesses: #{amt_guesses}"
    word.each { |char| print "#{char} " }
    puts
  end

  def separator
    puts '******************************************************************'
  end

  def query_player(guessed_array)
    valid_guess = false
    until valid_guess
      print 'Enter a character to guess: '
      guess = gets.chomp.downcase
      valid_guess = true if ('a'..'z').to_a.include?(guess) && !guessed_array.include?(guess)
    end
    guess
  end

  def print_guesses
    print "Correctly guessed: #{guessed_right}\n"
    print "Already guessed: #{guessed_wrong}\n"
    separator
  end
end

puts 'Hangman initialized!'

game = Hangman.new
game.play
