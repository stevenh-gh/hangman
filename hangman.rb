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
p sample = generate_random_word(dict)
