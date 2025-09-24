class CreateEarthquakes < ActiveRecord::Migration[8.0]
  def change
    create_table :earthquakes do |t|
      t.text :title
      t.bigint :event_id
      t.st_point :coordinates, geographic: true
      t.float :magnitude
      t.boolean :tsunami
      t.float :depth_km
      t.jsonb :metadata

      t.timestamps
    end
  end
end
