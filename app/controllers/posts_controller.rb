class PostsController < ApplicationController
  # before_filter :authenticate_user!
  # after_action :verify_authorized, except: [:index]
  # after_action :verify_policy_scoped, only: [:index]

  def index
    @posts = policy_scope(Post.limit(10))
    # @posts.each do |post|
    #   post[:content] = decrypt(current_user.name, post[:encrypted_content])
    # end
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    # @post = Post.new(params[:post])
    # @post.user = current_user
    @post = current_user.posts.build(secure_attributes)

    if @post.save
      redirect_to posts_path, notice: 'Post posted!'
    else
      render :new
    end



    # @post = current_user.posts.build(secure_attributes)
    # authorize @post
    # @post[:encrypted_content] = encrypt(current_user.name, @post.content)
    # if @post.save
    #   redirect_to posts_path, notice: 'Post posted!'
    # else
    #   render :new
    # end
  end

  def edit
    @post = Post.find(params[:id])

    # load_post
    # authorize @post
    # @post[:content] = decrypt(current_user.name, @post[:encrypted_content])
  end

  def new
    @post = Post.new
    # authorize @post
  end

  def update
    @post = Post.find(params[:id])

    # load_post
    # authorize @post
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

    # def decrypt(user, content)
    #   Post.decrypt_post(user, content)
    # end
    #
    # def encrypt(user, content)
    #   Post.encrypt_post(user, content)
    # end

end
