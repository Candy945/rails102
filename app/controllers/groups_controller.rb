class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create
  end

  def edit
    @group = Group.edit
  end

  def delete
    @group = Group.delete
  end

end
