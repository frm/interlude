require "httparty"

module Interlude
  class App
    def initialize(step: 1, dataset: nil)
      @step = step
      @dataset = dataset
    end

    def run
      each_word do |keyword|
        if correct_answer?(keyword)
          puts "FOUND IT! #{keyword}"
          break
        end
      end
    end

    private

    def step
      @_step ||= @step.to_s.rjust(2, "0")
    end

    def each_word(&block)
      File.open(@dataset, 'r') do |file|
        file.each_line do |line|
          block.call(line.strip)
        end
      end
    end

    def url(query)
      answer = query.gsub(' ', '_').downcase
      "http://quizchallenges.pixels.camp/ch3/#{step}-#{answer}.html"
    end

    def correct_answer?(query)
      HTTParty.get(url query).code == 200
    end
  end
end
