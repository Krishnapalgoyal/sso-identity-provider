class CreateServiceProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :service_providers do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :entity_id, null: false
      t.text :acs_url, null: false  # Assertion Consumer Service URL
      t.text :metadata_url
      t.text :certificate
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :service_providers, :entity_id
    add_index :service_providers, [:organization_id, :entity_id], unique: true
  end
end