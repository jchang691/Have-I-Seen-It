class RemoveMoviesPerPageFromUser < ActiveRecord::Migration
  def up
  	remove_column :users, :movies_per_page, :integer
  end

  def down
  	add_column :users, :movies_per_page, :integer
  end
end
