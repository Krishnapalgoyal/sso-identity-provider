class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Associations
  belongs_to :organization
  has_many :audit_logs, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: { scope: :organization_id }
  validates :role, inclusion: { in: %w[user admin super_admin] }

  # Scopes
  scope :admins, -> { where(role: 'admin') }

  # Class Methods
  def self.from_omniauth(auth, organization)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.organization = organization
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar_url = auth.info.image
    end
  end

  # Instance Methods
  def admin?
    role == 'admin' || role == 'super_admin'
  end

  def full_name
    "#{first_name} #{last_name}".strip.presence || email
  end
end