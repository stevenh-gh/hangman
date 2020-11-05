require_relative 'sample'

puts 'Hangman initialized!'

def load_dictionary
  File.readlines('5desk.txt').map { |row| row.chomp }
end

def display_word(word)
  word.each { |char| print "#{char} " }
  puts
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

def display_guess(amt_guesses)
  puts "Amount of guesses: #{amt_guesses}"
end

dict = load_dictionary
# sample.random_word = generate_random_word dict
sample = Sample.new
p sample.random_word

amt_guesses = 6 # Stick figure takes 6 marks to complete

word = Array.new sample.random_word.length, '_'

# Display amount of guesses
display_guess amt_guesses

# Display word
display_word word

puts '******************************************************************'

guessed_right = []
guessed_wrong = []

loop do
  # Ask user to guess
  guess = query_player(guessed_right + guessed_wrong)

  if sample.random_word.downcase.include? guess
    word.map!.with_index { |ele, idx| sample.random_word[idx].downcase == guess ? sample.random_word[idx] : ele }
    guessed_right << guess
  else
    amt_guesses -= 1
    guessed_wrong << guess
  end

  display_guess amt_guesses
  display_word word
  print "Correctly guessed: #{guessed_right}\n"
  print "Already guessed: #{guessed_wrong}\n"
  puts '******************************************************************'

  if amt_guesses == 0
    puts 'You have failed to guess the word!'
    break
  end

  if word.join('') == sample.random_word
    puts 'You have guessed the word correctly!'
    break
  end
end
