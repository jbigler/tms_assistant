class UsersController < ApplicationController

  def set_default_congregation
    if params[:default_congregation]
      @user = User.find( params[:id] )
      if @user.congregation_ids.include? params[:default_congregation].to_i
        @user.default_congregation_id = params[:default_congregation]
        flash[:notice] = "New default congregation assigned." if @user.save
        session[:congregration_id] = params[:default_congregation]
      end
    end
    redirect_to congregations_path
  end
end
