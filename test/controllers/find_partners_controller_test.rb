require "test_helper"

class FindPartnersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get find_partners_index_url
    assert_response :success
  end
end
