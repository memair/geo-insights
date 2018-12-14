class AddLatestLatLngToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :latest_latitude, :float
    add_column :users, :latest_longitude, :float
  end
end
