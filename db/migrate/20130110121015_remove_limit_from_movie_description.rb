class RemoveLimitFromMovieDescription < ActiveRecord::Migration
  def up
    change_column :movies, :description, :text, :limit => nil
  end

  def down
  end
end
