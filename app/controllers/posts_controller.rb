class PostsController < ApplicationController
  layout "inertia"

  def index
    render inertia: "Posts/Index", props: {
      posts: Post.order(created_at: :desc).map { |post|
        serialize_post(post)
      }
    }
  end

  def show
    post = Post.find(params[:id])
    render inertia: "Posts/Show", props: {
      post: serialize_post(post)
    }
  end

  def new
    render inertia: "Posts/New"
  end

  def create
    post = Post.new(post_params)

    if post.save
      redirect_to post_path(post)
    else
      render inertia: "Posts/New", props: {
        errors: post.errors.messages
      }, status: :unprocessable_content
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.expect(post: [:title, :body])
  end

  def serialize_post(post)
    {
      id: post.id,
      title: post.title,
      body: post.body,
      created_at: post.created_at.iso8601,
      updated_at: post.updated_at.iso8601
    }
  end
end
