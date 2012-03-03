class DashboardController < ApplicationController
  before_filter :authenticate_user!  

  def index
    @congregations = current_user.congregations

    if params[:congregation_id]
      @congregation = current_user.congregations.find( params[:congregation_id] )
      session[:congregation_id] = current_user.default_congregation.id
    elsif session[:congregation_id]
      @congregation = current_user.congregations.find( session[:congregation_id] )
    elsif current_user.default_congregation
      @congregation = current_user.congregations.find( current_user.default_congregation ) 
      session[:congregation_id] = current_user.default_congregation.id
    end

    if @congregation
      @school_sessions = @congregation.school_sessions.incomplete.order("week_of ASC")
    end
  end
end
