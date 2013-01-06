class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.integer :rating
      t.integer :year
      t.string :description

      t.timestamps
    end
  end
end
