class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :authenticate_user!, :set_locale

  private

  def set_locale
    # params[:locale] is for override
    if params[:locale]
      session[:locale] = params[:locale]
    elsif current_user
      session[:locale] = current_user.locale
    else
      session[:locale] ||= I18n.default_locale
    end
    I18n.locale = session[:locale]
  end

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
