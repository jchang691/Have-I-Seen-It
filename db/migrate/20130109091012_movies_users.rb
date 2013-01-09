class MoviesUsers < ActiveRecord::Migration
  def up
        create_table :movies_users, :id=> false do |t|
        t.references :user, :null => false
        t.references :movie, :null => false
    end
  end

  def down
  end
end
