class Admin::UsersController < Admin::BaseController

  layout "application-single"
  
  before_filter :find_user, :only => [:edit, :update, :destroy, :set_default_congregation]
  
  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "User created!"
      redirect_to admin_users_url
    else
      render :action => 'new'
    end
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated #{@user.name}."
      redirect_to admin_users_url
    else
      render :action => 'edit'
    end
  end

  def set_default_congregation
    if params[:default_congregation]
      if @user.congregation_ids.include? params[:default_congregation].to_i
        @user.default_congregation_id = params[:default_congregation]
        flash[:notice] = "New default congregation assigned." if @user.save
      end
    end
    redirect_to congregations_path
  end

  def destroy
    @user.destroy
    flash[:notice] = "User deleted."
    redirect_to admin_users_url
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
