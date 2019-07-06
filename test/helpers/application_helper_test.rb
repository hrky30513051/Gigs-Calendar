require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Gigs Calendar"
    assert_equal full_title("Help"), "Help | Gigs Calendar"
  end
end