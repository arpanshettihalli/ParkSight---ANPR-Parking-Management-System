class CreateParkingSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :parking_sessions do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.datetime :entry_time
      t.datetime :exit_time
      t.string :status
      t.decimal :amount

      t.timestamps
    end
  end
end
