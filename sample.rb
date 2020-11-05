class Sample
  attr_reader :random_word, :length

  def initialize
    @random_word = generate_random_word
    @length = random_word.length
  end

  private

  # TODO: make dict class and pass it in here
  def generate_random_word(dict)
    sample = ''
    loop do
      sample = dict.sample
      break if sample.length > 5 && sample.length < 12
    end
    sample
  end
end
