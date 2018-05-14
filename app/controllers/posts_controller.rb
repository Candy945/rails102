class PostsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only:[:edit, :update, :destroy]


  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)

    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render new
    end
  end

  def edit
    @post = Post.find(post_params)

  end

  def update
    @post = Post.find(post_params)
    if @post.update(post_params)
      redirect_to groups_path, notice:"Update Success"
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:alert]="Post deleted"
    redirect_to groups_path
  end

   private

   def find_group_and_check_permission
     @group = Group.find(params[:group_id])
     if current_user != @group.user
       redirect_to root_path, alert: "You have no permission."
     end
   end

   def post_params
     params.require(:post).permit(:content)
   end
