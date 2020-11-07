require 'pry'
require 'json'
require_relative 'sample'

class Hangman
  attr_accessor :dict, :sample, :amt_guesses, :word, :guessed_right, :guessed_wrong

  def initialize(sample = nil, amt_guesses = nil, word = nil, guessed_right = nil, guessed_wrong = nil)
    @dict = load_dictionary
    @sample = sample || Sample.new(dict)
    @amt_guesses = amt_guesses || 6 # Stick figure takes 6 marks to complete
    @word = word || Array.new(self.sample.length, '_')
    @guessed_right = guessed_right || []
    @guessed_wrong = guessed_wrong || []
  end

  def play
    loop do
      display_word_guess word, amt_guesses
      separator

      query_save

      guess = query_player(guessed_right + guessed_wrong)

      process_guess guess

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

  def process_guess(guess)
    if sample.random_word.downcase.include? guess
      word.map!.with_index { |ele, idx| sample.random_word[idx].downcase == guess ? sample.random_word[idx] : ele }
      guessed_right << guess
    else
      self.amt_guesses -= 1
      guessed_wrong << guess
    end
  end

  def query_save
    # Ask user if they want to save the game
    yn = false
    until yn
      print 'Do you want to save game? (Y/N): '
      save_game = gets.chomp.downcase
      yn = true if save_game == 'y' || save_game == 'n'
    end
    if save_game == 'y'
      savefile = to_json
      Dir.mkdir 'save' unless Dir.exist? 'save'
      filename = 'save/savefile.json'
      f = File.open filename, 'w'
      f.puts savefile
      f.close
      puts "Saved to folder 'save'!"
      true
    end
  end

  def to_json(*_args)
    JSON.dump(
      {
        sample: @sample.random_word,
        amt_guesses: @amt_guesses,
        word: @word,
        guessed_right: @guessed_right,
        guessed_wrong: @guessed_wrong,
        dict: @dict
      }
    )
  end

  def self.from_json(string)
    data = JSON.load string
    s = Sample.new(data['dict'])
    s.random_word = data['sample']
    new(
      s,
      data['amt_guesses'],
      data['word'],
      data['guessed_right'],
      data['guessed_wrong']
    )
  end
end

puts 'Hangman initialized!'

puts

loop do
  yn = false
  until yn
    print 'Do you want to open savefile? (Y/N): '
    input = gets.chomp.downcase
    yn = true if input == 'y' || input == 'n'
  end

  game = input == 'y' ? Hangman.from_json(File.open('save/savefile.json', 'r').read) : Hangman.new

  game.play

  loopans = false
  until loopans
    print 'Do you want to play again? (Y/N): '
    loop = gets.chomp.downcase
    loopans = true if input == 'y' || input == 'n'
  end
  break if loop == 'n'
end
