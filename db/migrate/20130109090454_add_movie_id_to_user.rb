class AddMovieIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :movie_id, :integer
  end
end
