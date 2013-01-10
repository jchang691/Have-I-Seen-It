class RenameMoviesActorsToActorsMovies < ActiveRecord::Migration
  def up
    rename_table :movies_actors, :actors_movies
  end

  def down
  end
end
