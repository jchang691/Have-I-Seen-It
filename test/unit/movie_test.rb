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

require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
