class ApplicationController < ActionController::Base

  protect_from_forgery

  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  private

  def require_congregation
    if params[:congregation_id]
      if current_user.admin?
        @congregation = Congregation.find( session[:congregation_id] )
      else
        @congregation = current_user.congregations.find( session[:congregation_id] )
      end
    elsif session[:congregation_id]
      if current_user.admin?
        @congregation = Congregation.find( session[:congregation_id] )
      else
        @congregation = current_user.congregations.find( session[:congregation_id] )
      end
    else
      if current_user.default_congregation
        @congregation = current_user.congregations.find( current_user.default_congregation )
        session[:congregation_id] = current_user.default_congregation.id
      else
        flash[:alert] = "Please select a congregation to manage."
        redirect_to congregations_path
      end
    end
  end

end
