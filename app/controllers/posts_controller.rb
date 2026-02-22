class PostsController < InertiaController
  def index
    render inertia: {
      posts: Post.order(created_at: :desc).as_json(only: %i[id title body created_at updated_at])
    }
  end

  def show
    render inertia: {
      post: Post.find(params[:id]).as_json(only: %i[id title body created_at updated_at])
    }
  end

  def new
  end

  def create
    post = Post.new(post_params)

    if post.save
      redirect_to post_path(post)
    else
      redirect_to new_post_path, inertia: {errors: post.errors}
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
end
