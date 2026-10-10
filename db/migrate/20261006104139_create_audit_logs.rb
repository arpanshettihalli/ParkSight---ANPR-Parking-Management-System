class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.string :event_type
      t.string :plate_number
      t.jsonb :details

      t.timestamps
    end
  end
end
