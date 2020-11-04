puts 'Hangman initialized!'

def generate_random_word(dict)
  sample = ''
  loop do
    sample = dict.sample
    break if sample.length > 5 && sample.length < 12
  end
  sample
end

def load_dictionary
  File.readlines('5desk.txt').map { |row| row.chomp }
end

dict = load_dictionary
sample = generate_random_word(dict)

AMT_GUESSES = 6 # Stick figure takes 6 marks to complete
