require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @search = users(:lana)
  end

  test "index as admin only venue including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count:2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      if user.venue?
        assert_select 'a[href=?]', user_path(user), text: user.name, count: 1
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: 'delete'
        end
      else
        assert_select 'a[href=?]', user_path(user), text: user.name, count: 0
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index search" do
    log_in_as(@admin)
    get users_path, params: { search: @search.name }
    assert_select 'a[href=?]', user_path(@search), text: @search.name, count: 1
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end