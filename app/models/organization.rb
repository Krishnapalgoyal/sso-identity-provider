class Organization < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :subdomain, presence: true, 
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-z0-9-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }
  validates :api_key, presence: true, uniqueness: true

  # Callbacks
  before_validation :generate_api_credentials, on: :create
  before_validation :normalize_subdomain

  # Associations
  has_many :users, dependent: :destroy

  # Scopes
  scope :active, -> { where(active: true) }

  # Instance Methods
  def regenerate_api_key!
    generate_api_credentials
    save!
  end

  def verify_api_secret(secret)
    BCrypt::Password.new(api_secret_digest) == secret
  end

  private

  def generate_api_credentials
    self.api_key = SecureRandom.hex(32)
    self.api_secret_digest = BCrypt::Password.create(SecureRandom.hex(32))
  end

  def normalize_subdomain
    self.subdomain = subdomain.to_s.downcase.strip
  end
end