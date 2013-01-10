class MoviesActors < ActiveRecord::Migration
  def up
    create_table :movies_actors, :id => false do |t|
        t.references :movies, :null => false
        t.references :actors, :null => false
    end
  end

  def down
  end
end
