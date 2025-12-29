# db/migrate/XXXXXX_devise_create_users.rb
class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      # Organization reference (excluded from tenancy)
      t.references :organization, null: false, foreign_key: true

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## OAuth
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :avatar_url

      ## Role
      t.string :role, default: 'user'

      t.timestamps null: false
    end

    add_index :users, :email
    add_index :users, :reset_password_token, unique: true
    add_index :users, [:organization_id, :email], unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end