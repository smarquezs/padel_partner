require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with valid attributes" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.valid?
    assert user.save
  end

  test "should require email" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should require password" do
    user = User.new(email: "test@example.com")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end

  test "should require password to be at least 8 characters" do
    user = User.new(
      email: "test@example.com",
      password: "short",
      password_confirmation: "short"
    )
    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end

  test "should require unique email" do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "should downcase email before saving" do
    user = User.create!(
      email: "TEST@EXAMPLE.COM",
      password: "password123",
      password_confirmation: "password123"
    )
    assert_equal "test@example.com", user.email
  end

  test "should authenticate with correct password" do
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    assert user.authenticate("password123")
    assert_not user.authenticate("wrongpassword")
  end

  test "should generate password reset token" do
    user = User.new(
      email: "testreset@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    user.save!
    
    # Just test that generate_password_reset_token sets token and time
    user.generate_password_reset_token
    
    assert_not_nil user.password_reset_token
    assert_not_nil user.password_reset_sent_at
  end

  test "should detect expired password reset token" do
    user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    
    # Set token to 2 hours ago
    user.update!(
      password_reset_token: "token123",
      password_reset_sent_at: 2.hours.ago
    )
    
    assert user.password_reset_expired?
    
    # Set token to 30 minutes ago
    user.update!(password_reset_sent_at: 30.minutes.ago)
    assert_not user.password_reset_expired?
  end
end
