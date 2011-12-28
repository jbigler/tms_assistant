class LessonSourcesController < ApplicationController

  before_filter :authenticate_user!, :initialize_language
  layout "application-single"

  # GET /lesson_sources
  # GET /lesson_sources.xml
  def index
    @lesson_sources = @language.lesson_sources.order( "chapter" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lesson_sources }
    end
  end

  # GET /lesson_sources/1
  # GET /lesson_sources/1.xml
  def show
    @lesson_source = @language.lesson_sources.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lesson_source }
    end
  end

  # GET /lesson_sources/1/edit
  def edit
    @lesson_source = @language.lesson_sources.find(params[:id])
  end

  # PUT /lesson_sources/1
  # PUT /lesson_sources/1.xml
  def update
    @lesson_source = @language.lesson_sources.find( params[:id] )

    respond_to do |format|
      if @lesson_source.update_attributes(params[:lesson_source])
        format.html { redirect_to( language_lesson_source_path( @language, @lesson_source ), :notice => 'Lesson source was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lesson_source.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  def initialize_language
    @language = Language.find( params[:language_id] )
  end
end
