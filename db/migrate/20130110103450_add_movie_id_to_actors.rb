class AddMovieIdToActors < ActiveRecord::Migration
  def change
    add_column :actors, :movie_id, :integer
  end
end
