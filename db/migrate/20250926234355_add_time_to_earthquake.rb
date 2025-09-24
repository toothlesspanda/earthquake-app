class AddTimeToEarthquake < ActiveRecord::Migration[8.0]
  def change
    add_column :earthquakes, :occurred_at, :datetime
  end
end
