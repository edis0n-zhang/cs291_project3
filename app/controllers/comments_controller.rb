class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @post, notice: "Comment added successfully."
    else
      @comments = @post.comments.order(created_at: :asc)
      render 'posts/show'
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    unless @post
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
