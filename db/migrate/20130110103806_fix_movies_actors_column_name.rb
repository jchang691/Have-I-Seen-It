class FixMoviesActorsColumnName < ActiveRecord::Migration
  def up
    rename_column :movies_actors, :actors_id, :actor_id
    rename_column :movies_actors, :movies_id, :movie_id
  end

  def down
  end
end
