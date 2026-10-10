class CreateDetections < ActiveRecord::Migration[8.1]
  def change
    create_table :detections do |t|
      t.references :parking_session, null: false, foreign_key: true
      t.string :plate_number
      t.float :confidence
      t.datetime :detected_at

      t.timestamps
    end
  end
end
