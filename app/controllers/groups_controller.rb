class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only:[:edit, :update, :destroy]


  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page],:per_page => 5)

  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice:"Update Success"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:alert]="Group deleted"
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "你已成功加入本群"
    else
      flash[:warning] = "你已经是本群成员了"
    end

    redirect_to group_path(@group)

  end

   def quit
     @group = Group.find(params[:id])

     if current_user.is_member_of?(@group)
       current_user.quit!(@group)
       flash[:alert] = "你已退出群组"
     else
       flash[:warning] = "你不是本群组成员，怎么退出？"
     end
     redirect_to group_path(@group)
   end


  private

    def find_group_and_check_permission
      @group = Group.find(params[:id])
      if current_user != @group.user
        redirect_to root_path, alert: "You have no permission."
      end
    end


    def group_params
      params.require(:group).permit(:title, :description)
    end

end
