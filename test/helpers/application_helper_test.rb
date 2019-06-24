require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Gigs Calender"
    assert_equal full_title("Help"), "Help | Gigs Calender"
  end
end