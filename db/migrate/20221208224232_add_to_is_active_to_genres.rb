class AddToIsActiveToGenres < ActiveRecord::Migration[6.1]
  def change
    add_column :genres, :is_active, :boolean, default: true
    
  end
end
