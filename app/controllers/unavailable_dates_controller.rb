class UnavailableDatesController < ApplicationController

  before_filter :require_congregation, :require_student, :prepare_calendar

  layout "application-double"

  def index
    @unavailable_dates = @student.unavailable_dates.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @unavailable_dates }
    end
  end

  def show
    @unavailable_date = @student.unavailable_dates.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @unavailable_date }
    end
  end

  def new
    # TODO Update to find any items in the range
    if params[ :edit_date ]
      start_date = Date.parse( params[ :edit_date ] )
      @unavailable_date = @student.unavailable_dates.where( :start_date => start_date ).first
      if @unavailable_date
        redirect_to edit_congregation_student_unavailable_date_path( @congregation, @student, @unavailable_date )
        return
      else
        @unavailable_date = @student.unavailable_dates.build( :start_date => start_date )
      end
    else
      flash[:error] = "The start date must be passed as a parameter."
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @unavailable_date }
    end
  end

  def edit
    @unavailable_date = @student.unavailable_dates.find( params[:id] )
  end

  def create
    @unavailable_date = @student.unavailable_dates.build( params[:unavailable_date] )

    respond_to do |format|
      if @unavailable_date.save
        format.html { redirect_to( [@congregation, @student, @unavailable_date], :notice => 'unavailable date was successfully created.') }
        format.xml  { render :xml => @unavailable_date, :status => :created, :location => @unavailable_date }
      else
        format.html { render :action => "new", :alert => "Unable to create Unavailable date." }
        format.xml  { render :xml => @unavailable_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @unavailable_date = @student.unavailable_dates.find( params[:id] )

    respond_to do |format|
      if @unavailable_date.update_attributes( params[:unavailable_date] )
        format.html { redirect_to( [@congregation, @student, @unavailable_date], :notice => 'unavailable date was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @unavailable_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_dates/1
  # DELETE /special_dates/1.xml
  def destroy
    @unavailable_date = @student.unavailable_dates.find( params[:id] )
    @unavailable_date.destroy

    respond_to do |format|
      format.html { redirect_to( congregation_student_unavailable_dates_path( @congregation, @student ) ) }
      format.xml  { head :ok }
    end
  end
  private

  def require_student
    @student = @congregation.students.find( params[ :student_id ] )
  end

  def prepare_calendar
    if params[:calendar_date]
      @calendar_date = Date.parse( params[ :calendar_date ] )
    #elsif params[:id]
      #@special_date = @student.unavailable_dates.find( params[:id] )
      #@calendar_date = @special_date.start_date
    else
      @calendar_date = Date.today
    end
    @calendar_date = Date.civil( @calendar_date.year, @calendar_date.month, 1 )
    @selected_week = Date.parse( params[:selected_week] ) if params[:selected_week]
  end
end
