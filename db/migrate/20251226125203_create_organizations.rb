class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :subdomain, null: false
      t.string :api_key, null: false
      t.string :api_secret_digest
      t.boolean :active, default: true
      t.jsonb :saml_settings, default: {}

      t.timestamps
    end

    add_index :organizations, :subdomain, unique: true
    add_index :organizations, :api_key, unique: true
  end
end