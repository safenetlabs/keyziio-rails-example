class PostsController < ApplicationController
  # before_filter :authenticate_user!
  # after_action :verify_authorized

  def index
    @posts = Post.limit(10)
  end

  def show
    load_post
  end

  def create
    @post = Post.new(secure_attributes)
    if @post.save
      redirect_to posts_path, notice: 'Post posted!'
    else
      render :new
    end
  end

  def edit
    load_post
  end

  def new
    @post = Post.new
  end

  def update
    load_post
    if @post.update_attributes(secure_attributes)
      redirect_to posts_path, notice: 'Post updated!'
    else
      render :edit
    end
  end

  def destroy
    load_post
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
