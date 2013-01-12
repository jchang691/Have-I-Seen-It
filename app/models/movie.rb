# == Schema Information
#
# Table name: movies
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  rating              :integer
#  year                :integer
#  description         :text(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  rotten_tomatoes_url :string(255)
#

require 'nokogiri'
require 'open-uri'
class Movie < ActiveRecord::Base

    # validates :year, :numericality => {:only_integer => true}
    validates :name, :uniqueness => true

    has_and_belongs_to_many :users
    has_and_belongs_to_many :actors

    attr_writer :current_step
    attr_accessor :rottentomato

    self.per_page = 10

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
