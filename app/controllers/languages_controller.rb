class LanguagesController < ApplicationController
  
  layout "application-single"

  def index
    @languages = Language.all
  end

  def show
    @language = Language.find( params[:id] )
  end

end
