# db/migrate/XXXXXX_create_audit_logs.rb
class CreateAuditLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_logs do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :action, null: false
      t.string :resource_type
      t.bigint :resource_id
      t.jsonb :metadata, default: {}
      t.inet :ip_address

      t.timestamps
    end

    add_index :audit_logs, :action
    add_index :audit_logs, [:resource_type, :resource_id]
    add_index :audit_logs, :created_at
  end
end