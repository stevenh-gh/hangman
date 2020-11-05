class Sample
  attr_reader :random_word, :length

  def initialize(dict)
    @random_word = generate_random_word dict
    @length = random_word.length
  end

  private

  def generate_random_word(dict)
    sample = ''
    loop do
      sample = dict.sample
      break if sample.length > 5 && sample.length < 12
    end
    sample
  end
end
