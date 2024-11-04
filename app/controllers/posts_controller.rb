class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    if params[:username].present?
      @posts = Post.by_username(params[:username]).recent_first
    else
      @posts = Post.recent_first
    end
  end

  def show
    @comments = @post.comments.order(created_at: :asc)
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post created successfully."
    else
      render :new
    end
  end

  def edit
    # Renders the edit form
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, notice: "Post deleted successfully."
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
