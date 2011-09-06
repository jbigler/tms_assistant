class SchedulesController < ApplicationController

  before_filter :authenticate_user!, :initialize_language, :prepare_calendar

  # GET /languages/1/schedules
  # GET /languages/1/schedules.xml
  def index
    next_month = @calendar_date >> 1
    end_date = Date.civil( next_month.year, next_month.month, -1 )

    @schedules = @language.schedules.where( :week_of => @calendar_date..end_date ).order( "week_of" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end
 
  # GET /languages/1/schedules/1
  # GET /languages/1/schedules/1.xml
  def show
    @schedule = @language.schedules.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

   def new
    if params[ :edit_date ]
      edit_date = Date.parse( params[ :edit_date ] )
      weekday = edit_date.wday
      if weekday != 1
        if weekday > 1
          edit_date = edit_date - ( weekday - 1 )
        else
          edit_date = edit_date - 6
        end
      end
      schedule = @language.schedules.find_or_create_by_week_of( edit_date )
      schedule.save
      redirect_to edit_language_schedule_url( @language, schedule.id )
    else
      redirect_to language_schedules_path( @language )
    end
  end

  # GET /languages/1/schedules/1/edit
  def edit
    @schedule = @language.schedules.find( params[:id] )
    @selected_week = @schedule.week_of
  end

  # PUT /languages/1/schedules/1
  # PUT /languages/1/schedules/1.xml
  def update
    @schedule = @language.schedules.find( params[:id] )

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        format.html { redirect_to( [@language, @schedule], :notice => 'Schedule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_calendar
    respond_to do | format |  
        format.js {render :layout => false}  
    end
  end

  private

  def prepare_calendar
    if params[ :calendar_date ]
      @calendar_date = Date.parse( params[ :calendar_date ] )
    elsif params[ :id ]
      schedule = @language.schedules.find( params[ :id ] )
      @calendar_date = schedule.week_of
    else
      @calendar_date = Date.today
    end
    @calendar_date = Date.civil( @calendar_date.year, @calendar_date.month, 1 )
    @selected_week = Date.parse( params[:selected_week] ) if params[:selected_week]
  end

  def initialize_language
    @language = Language.find( params[:language_id] )
  end

end
