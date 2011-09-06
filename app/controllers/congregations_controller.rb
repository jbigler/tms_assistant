class CongregationsController < ApplicationController 

  before_filter :authenticate_user!  

  def index
    @congregations = current_user.congregations
  end

  # GET /languages/1/congregations/1
  # GET /languages/1/congregations/1.xml
  def show
    if current_user.admin?
      @congregation = Congregation.find( params[:id] )
    else
      @congregation = current_user.congregations.find( params[:id] )
    end
    if @congregation
      session[:congregation_id] = @congregation.id
    else
      redirect_to congregations_path
    end
  end

  def new
    @congregation = current_user.congregations.new
  end

  def edit
    if current_user.admin?
      @congregation = Congregation.find( params[:id] )
    else
      @congregation = current_user.congregations.find( params[:id] )
    end
  end

  def create
    @congregation = current_user.congregations.build( params[:congregation] )
    if @congregation.valid? and current_user.save
      flash[:notice] = "Congregation created."
      redirect_to congregation_url( @congregation )
    else
      render :action => 'new'
    end
  end

  def update
    if current_user.admin?
      @congregation = Congregation.find( params[:id] )
    else
      @congregation = current_user.congregations.find( params[:id] )
    end
    if @congregation and @congregation.update_attributes(params[:congregation])
      flash[:notice] = "Successfully updated congregation."
      redirect_to congregation_url( @congregation )
    else
      render :action => 'edit'
    end
  end

  def destroy
    if current_user.admin?
      @congregation = Congregation.find( params[:id] )
    else
      @congregation = current_user.congregations.find( params[:id] )
    end
    if @congregation and @congregation.destroy
      flash[:notice] = "Congregation deleted."
    else
      flash[:error] = "Unable to delete congregation."
    end
    redirect_to congregations_url
  end
end
