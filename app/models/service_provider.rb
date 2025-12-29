class ServiceProvider < ApplicationRecord
  # ActsAsTenant - belongs to organization
  acts_as_tenant :organization
  
  # Associations
  belongs_to :organization

  # Validations
  validates :name, presence: true
  validates :entity_id, presence: true, uniqueness: { scope: :organization_id }
  validates :acs_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  # Scopes
  scope :active, -> { where(active: true) }

  # Instance Methods
  def metadata_xml
    # Generate SAML metadata for this SP
    # Will implement in SAML controller
  end
end