require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 無効な送信
    post microposts_path, params: { micropost: { content: "" } }
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "This micropost really ties the room together"
    event_date = Date.tomorrow
    picture = fixture_file_upload('test/fixtures/test_image.jpg', 'image/jpg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost:
                                      { content: content,
                                        event_date: event_date,
                                        picture: picture } }
    end
    assert assigns(:micropost).picture?
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', { text: 'delete', count: 0 }
  end

  # test "micropost sidebar count" do
  #   log_in_as(@user)
  #   get root_path
  #   assert_match "#{@user.microposts.count} microposts", response.body
  #   # まだマイクロポストを投稿していないユーザー
  #   other_user = users(:malory)
  #   log_in_as(other_user)
  #   get root_path
  #   assert_match "0 microposts", response.body
  #   other_user.microposts.create!(content: "A micropost", event_date: 2.days.since)
  #   get root_path
  #   assert_match "1 micropost", response.body
  # end
end