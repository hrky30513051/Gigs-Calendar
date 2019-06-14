require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 3
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  def setup
    @user       = users(:michael)
    @other_user       = users(:archer)
  end
  
  test "layout links when logged in" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)    
    assert_select "a[href=?]", logout_path
  end

  test "layout links when logged in as other_user" do
    log_in_as(@other_user)
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination'
    assert_select 'input[type=file]', {count: 0}
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@other_user)
    assert_select "a[href=?]", edit_user_path(@other_user)    
    assert_select "a[href=?]", logout_path
  end

end