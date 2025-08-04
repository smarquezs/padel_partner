require "application_system_test_case"

class FindPartnersTest < ApplicationSystemTestCase
  setup do
    @current_user = users(:one)
    @other_user = users(:two)
    
    # Create availabilities for testing
    @current_user.availabilities.create!(
      day_of_week: 1, # Monday
      start_time: "17:00",
      end_time: "19:00"
    )
    
    @other_user.availabilities.create!(
      day_of_week: 1, # Monday
      start_time: "18:00",
      end_time: "20:00"
    )
  end

  test "requires authentication" do
    visit find_partners_path
    assert_current_path login_path
    assert_text "You must be logged in to perform that action"
  end

  test "displays form with default values" do
    sign_in_as(@current_user)
    visit find_partners_path
    
    assert_text "Find Partners"
    assert_selector "select[name='day_of_week']"
    assert_selector "input[name='start_time']"
    assert_selector "input[name='end_time']"
    assert_button "Search Partners"
  end

  test "finds partners with overlapping availability" do
    sign_in_as(@current_user)
    visit find_partners_path
    
    # Search for Monday 18:30 - 19:30 (should overlap with other_user)
    select "Monday", from: "day_of_week"
    fill_in "start_time", with: "18:30"
    fill_in "end_time", with: "19:30"
    click_button "Search Partners"
    
    # Should find the other user
    assert_text "User Two"
    assert_text "user2@example.com"
    assert_text "Available times:"
    
    # Should not show current user
    assert_no_text "User One"
  end

  test "shows empty state when no partners found" do
    sign_in_as(@current_user)
    visit find_partners_path
    
    # Search for a time when no one is available
    select "Sunday", from: "day_of_week"
    fill_in "start_time", with: "06:00"
    fill_in "end_time", with: "07:00"
    click_button "Search Partners"
    
    assert_text "No partners found for that time."
  end

  test "excludes current user from results" do
    sign_in_as(@current_user)
    visit find_partners_path
    
    # Search during current user's availability
    select "Monday", from: "day_of_week" 
    fill_in "start_time", with: "17:30"
    fill_in "end_time", with: "18:30"
    click_button "Search Partners"
    
    # Should not show current user even though they have availability
    assert_no_text "User One"
    assert_no_text "user1@example.com"
  end

  test "pagination with many users" do
    sign_in_as(@current_user)
    
    # Create 15 users with overlapping availability
    15.times do |i|
      user = User.create!(
        name: "Partner #{i + 1}",
        email: "partner#{i + 1}@example.com",
        password: "password123"
      )
      user.availabilities.create!(
        day_of_week: 2, # Tuesday
        start_time: "18:00",
        end_time: "20:00"
      )
    end
    
    visit find_partners_path
    
    # Search for Tuesday 19:00 - 20:00 (should match all 15 users)
    select "Tuesday", from: "day_of_week"
    fill_in "start_time", with: "19:00"
    fill_in "end_time", with: "20:00"
    click_button "Search Partners"
    
    # Should show 10 users on first page
    user_names = page.all("h3").map(&:text)
    assert_equal 10, user_names.length
    
    # Should have pagination controls
    assert_text "Next"
    
    # Click to second page
    click_link "Next"
    
    # Should show remaining 5 users
    user_names = page.all("h3").map(&:text)
    assert_equal 5, user_names.length
  end

  test "sorts results alphabetically by user name" do
    sign_in_as(@current_user)
    
    # Create users with names that will test sorting
    charlie = User.create!(
      name: "Charlie",
      email: "charlie@example.com", 
      password: "password123"
    )
    alice = User.create!(
      name: "Alice",
      email: "alice@example.com",
      password: "password123"
    )
    bob = User.create!(
      name: "Bob", 
      email: "bob@example.com",
      password: "password123"
    )
    
    # Give them all availability on Wednesday
    [charlie, alice, bob].each do |user|
      user.availabilities.create!(
        day_of_week: 3, # Wednesday
        start_time: "18:00",
        end_time: "20:00"
      )
    end
    
    visit find_partners_path
    
    select "Wednesday", from: "day_of_week"
    fill_in "start_time", with: "19:00"
    fill_in "end_time", with: "20:00"
    click_button "Search Partners"
    
    # Check that names appear in alphabetical order
    user_names = page.all("h3").map(&:text)
    expected_order = ["Alice", "Bob", "Charlie"]
    assert_equal expected_order, user_names[0, 3]
  end

  private

  def sign_in_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign In"
  end
end
