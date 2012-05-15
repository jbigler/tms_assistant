class SchoolSessionsController < ApplicationController

  before_filter :require_congregation, :prepare_calendar
  layout "application-double"

  def index
    next_month = @calendar_date >> 1
    end_date = Date.civil( next_month.year, next_month.month, -1 )

    @school_sessions = @congregation.school_sessions.where( :week_of => @calendar_date..end_date ).order( "week_of" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_sessions }
    end
  end

  def show
    @school_session = @congregation.school_sessions.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school_session }
    end
  end

  def new
    if params[:edit_date]
      week_of = Date.parse( params[:edit_date] )
      @school_session = @congregation.school_sessions.find_or_create_by_week_of( week_of )
      if @school_session.unassigned?
        redirect_to edit_congregation_school_session_path( @congregation, @school_session )
      elsif @school_session
        redirect_to congregation_school_session_path( @congregation, @school_session )
      else
        flash[:error] = "Unable to create school session for the date " + week_of.to_s
      end
    else
      flash[:notice] = "The week of the school must be passed as a parameter."
      redirect_to congregation_school_sessions_path( @congregation )
    end
  end

  def edit
    @school_session = @congregation.school_sessions.find( params[:id] )
    if @school_session.assigned?
      @school_session.unassign
    end
    if @school_session.completed?
      @school_session.undo
    end
    @selected_week = @school_session.week_of
    if params[:step_2] == "1"
      render 'edit_supp'
    end
  end

  def update
    @school_session = @congregation.school_sessions.find( params[:id] )

    respond_to do |format|
      if @school_session.update_attributes( params[:school_session] )
        if params[:step_2] == "1"
          format.html { redirect_to :action => "edit", :id => @school_session.id, :step_2 => "1" }
        else
          if @school_session.can_assign?
            @school_session.assign
          end
          @school_session.save
          format.html { redirect_to [@congregation,@school_session], :notice => "School Session was successfully updated." }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :notice => "Error saving changes." }
        format.xml  { render :xml => @school_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  def complete
    @school_session = @congregation.school_sessions.find( params[:id] )
    if @school_session and @school_session.assigned?
      @selected_week = @school_session.week_of
    else
      flash[:notice] = "School Session must be in Assigned state to be completed."
      redirect_to [@congregation, @school_session]
    end
  end

  def finalize
    @school_session = @congregation.school_sessions.find( params[:id] )
    if @school_session and @school_session.update_attributes( params[:school_session] )
      if @school_session.can_complete?
        @school_session.complete
        @school_session.save
        flash[:notice] = "All assignments completed."
        redirect_to [@congregation, @school_session]
      else
        puts "not complete"
        flash[:notice] = "Unable to complete all assignments."
        redirect_to complete_congregation_school_session_path( @congregation, @school_session )
      end
    else
      puts "couldn't save"
      flash[:notice] = "Error saving changes."
      redirect_to complete_congregation_school_session_path( @congregation, @school_session )
    end
  end

  def update_calendar
    respond_to do | format |  
        format.js {render :layout => false}  
    end
  end

  protected

  def get_current_monday_date
    today = Date.today
    if today.wday == 0
      return today + 1
    elsif today.wday > 1
      return today - ( today.wday - 1 )
    else
      return today
    end
  end

  private

  def prepare_calendar
    if params[:calendar_date]
      @calendar_date = Date.parse( params[ :calendar_date ] )
    elsif params[:id]
      @session = @congregation.school_sessions.find( params[:id] )
      @calendar_date = @session.week_of
    else
      @calendar_date = Date.today
    end
    @calendar_date = Date.civil( @calendar_date.year, @calendar_date.month, 1 )
    @calendar_states = calendar_states_hash
    @selected_week = Date.parse( params[:selected_week] ) if params[:selected_week]
  end

  def calendar_states_hash
    calendar_states = {}
    weeks = @congregation.school_sessions.select("week_of, state").where(:week_of => @calendar_date..(@calendar_date >> 2))
    weeks.each do |week|
      calendar_states[week.week_of] = week.state
    end
    return calendar_states
  end
end
