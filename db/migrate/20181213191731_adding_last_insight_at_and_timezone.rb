class AddingLastInsightAtAndTimezone < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_insight_at, :datetime
    add_column :users, :time_zone, :string
  end
end
