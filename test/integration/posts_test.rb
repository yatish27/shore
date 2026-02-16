require "test_helper"

class PostsTest < ActionDispatch::IntegrationTest
  test "create flow: new form, submit, redirect to show" do
    get new_post_path
    assert_response :success

    assert_difference "Post.count", 1 do
      post posts_path, params: {post: {title: "My New Post", body: "This is the post body."}}
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "list and view flow: index shows posts, can view individual post" do
    get posts_path
    assert_response :success

    post_record = posts(:one)
    get post_path(post_record)
    assert_response :success
  end

  test "delete flow: destroy post and redirect to index" do
    post_record = posts(:one)

    assert_difference "Post.count", -1 do
      delete post_path(post_record)
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "validation failure: blank params do not create post" do
    assert_no_difference "Post.count" do
      post posts_path, params: {post: {title: "", body: ""}}
    end

    assert_response :unprocessable_content
  end
end
