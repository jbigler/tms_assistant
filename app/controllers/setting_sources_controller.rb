class SettingSourcesController < ApplicationController

  before_filter :initialize_language

  # GET /setting_sources
  # GET /setting_sources.xml
  def index
    @setting_sources = @language.setting_sources.order( "number" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @setting_sources }
    end
  end

  # GET /setting_sources/1
  # GET /setting_sources/1.xml
  def show
    @setting_source = @language.setting_sources.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @setting_source }
    end
  end

  # GET /setting_sources/1/edit
  def edit
    @setting_source = @language.setting_sources.find( params[:id] )
  end

  # PUT /setting_sources/1
  # PUT /setting_sources/1.xml
  def update
    @setting_source = @language.setting_sources.find( params[:id] )

    respond_to do |format|
      if @setting_source.update_attributes(params[:setting_source])
        format.html { redirect_to([@language, @setting_source], :notice => t("flash.actions.update.notice", :model => SettingSource.model_name.human)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setting_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def initialize_language
    @language = Language.find( params[:language_id] )
  end
end
