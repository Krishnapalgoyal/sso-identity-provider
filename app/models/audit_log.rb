# app/models/audit_log.rb
class AuditLog < ApplicationRecord
  # ActsAsTenant
  acts_as_tenant :organization
  
  # Searchkick for Elasticsearch
  searchkick word_start: [:action, :resource_type],
             searchable: [:action, :resource_type, :metadata],
             filterable: [:action, :resource_type, :user_id, :created_at]

  # Associations
  belongs_to :organization
  belongs_to :user, optional: true

  # Validations
  validates :action, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_action, ->(action) { where(action: action) }
  scope :by_resource, ->(type, id) { where(resource_type: type, resource_id: id) }

  # Searchkick data
  def search_data
    {
      action: action,
      resource_type: resource_type,
      user_email: user&.email,
      user_name: user&.full_name,
      ip_address: ip_address&.to_s,
      metadata: metadata,
      created_at: created_at,
      organization_id: organization_id
    }
  end

  # Class Methods
  def self.log_action(action, user: nil, resource: nil, metadata: {}, ip: nil)
    create!(
      action: action,
      user: user,
      resource_type: resource&.class&.name,
      resource_id: resource&.id,
      metadata: metadata,
      ip_address: ip
    )
  end
end