class ChangeEventIdToStringInEarthquakes < ActiveRecord::Migration[8.0]
  def change
    change_column :earthquakes, :event_id, :string
  end
end
