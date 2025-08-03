class User < ApplicationRecord
  has_secure_password
  
  has_many :availabilities, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  before_save :downcase_email

  # Generate password reset token
  def generate_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.current
    save!
  end

  # Check if password reset token is valid (not expired)
  def password_reset_expired?
    password_reset_sent_at < 1.hour.ago
  end

  # Clear password reset token after successful reset
  def clear_password_reset_token
    self.password_reset_token = nil
    self.password_reset_sent_at = nil
    save!
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
