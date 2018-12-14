class AddDistanceToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :distance, :float, null: false
  end
end
