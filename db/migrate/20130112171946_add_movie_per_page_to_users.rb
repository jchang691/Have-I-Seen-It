class AddMoviePerPageToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :movies_per_page, :integer
  end
end
