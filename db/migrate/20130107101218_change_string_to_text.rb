class ChangeStringToText < ActiveRecord::Migration
  def up
    change_column :movies, :description, :text
  end

  def down
    change_column :movies, :description, :string
  end
end
