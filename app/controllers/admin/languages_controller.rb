class Admin::LanguagesController < Admin::BaseController

  layout "application-single"

  def index
    @languages = Language.all
  end

  def show
    @language = Language.find( params[:id] )
  end

  def new
    @language = Language.new
  end

  def create
    @language = Language.create(params[:language])
    if @language.save
      flash[:notice] = "Language created."
      redirect_to admin_language_url( @language )
    else
      render :action => 'new'
    end
  end

  def edit
    @language = Language.find( params[:id] )
  end

  def update
    @language = Language.find( params[:id] )
    if @language.update_attributes( params[:language] )
      flash[:notice] = "Successfuly updated language."
      redirect_to admin_language_url( @language )
    else
      render :action => 'edit'
    end
  end

  def destroy
    @language = Language.find( params[:id] )
    if @language and @language.destroy
      flash[:notice] = "Language deleted."
      redirect_to admin_languages_url
    else
      flash[:error] = "Unable to delete language."
      redirect_to admin_languages_url
    end
  end

end
