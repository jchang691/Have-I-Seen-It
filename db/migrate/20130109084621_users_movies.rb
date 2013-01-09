class UsersMovies < ActiveRecord::Migration
  def up
    create_table :users_movies, :id=> false do |t|
        t.references :user, :null => false
        t.references :movie, :null => false
    end
  end

  def down
  end
end
