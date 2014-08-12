class PostsController < ApplicationController
  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @posts = policy_scope(Post.limit(10))
  end

  def create
    @post = current_user.posts.build(secure_attributes)
    authorize @post
    if @post.save
      redirect_to posts_path, notice: 'Post posted!'
    else
      render :new
    end
  end

  def edit
    load_post
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

  def update
    load_post
    authorize @post
    if @post.update_attributes(secure_attributes)
      redirect_to posts_path, notice: 'Post updated!'
    else
      render :edit
    end
  end

  def destroy
    load_post
    authorize @post
    @post.destroy
    redirect_to posts_path, notice: 'Post unposted!'
  end

  private

    def load_post
      @post = Post.find(params[:id])
    end

    def secure_attributes
      params.require(:post).permit(:title, :content)
    end
end
