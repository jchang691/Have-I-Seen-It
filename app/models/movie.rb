require 'nokogiri'
require 'open-uri'
class Movie < ActiveRecord::Base

    # validates :year, :numericality => {:only_integer => true}
    validates :name, :uniqueness => true

    attr_writer :current_step
    attr_accessor :rottentomato

    def current_step
        @current_step || steps.first
    end

    def steps
        %w[form rottentomatoes]
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end

    def all_valid?
        steps.all? do |step|
            self.current_step = step
            valid?
        end
    end

    def rotten_tomatoes_link
        @rottentomato ||= Nokogiri::HTML(open("http://www.rottentomatoes.com/search/?search=#{name.gsub(" ", "+")}"))
    end
end
