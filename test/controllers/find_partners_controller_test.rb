require "test_helper"

class FindPartnersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should redirect to login when not authenticated" do
    get find_partners_path
    assert_redirected_to login_path
  end

  test "should get index when authenticated" do
    sign_in_as(@user)
    get find_partners_path
    assert_response :success
    assert_select "h1", "Find Partners"
  end

  test "should find partners with overlapping availability" do
    other_user = users(:two)
    
    # Create availability for current user
    @user.availabilities.create!(
      day_of_week: 1,
      start_time: "17:00",
      end_time: "19:00"
    )
    
    # Create overlapping availability for other user
    other_user.availabilities.create!(
      day_of_week: 1,
      start_time: "18:00", 
      end_time: "20:00"
    )
    
    sign_in_as(@user)
    get find_partners_path, params: {
      day_of_week: 1,
      start_time: "18:30",
      end_time: "19:30"
    }
    
    assert_response :success
    assert_select "h3", other_user.name
  end

  private

  def sign_in_as(user)
    post login_path, params: {
      email: user.email,
      password: "password123"
    }
  end
end
