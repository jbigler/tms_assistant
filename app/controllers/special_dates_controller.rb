class SpecialDatesController < ApplicationController

  before_filter :require_congregation, :prepare_calendar
  layout "application-double"

  # GET /special_dates
  # GET /special_dates.xml
  def index
    next_month = @calendar_date >> 1
    end_date = Date.civil( next_month.year, next_month.month, -1 )

    @special_dates = @congregation.special_dates.where( :week_of => @calendar_date..end_date ).order( "week_of" )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @special_dates }
    end
  end

  # GET /special_dates/1
  # GET /special_dates/1.xml
  def show
    @special_date = @congregation.special_dates.find( params[:id] )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @special_date }
    end
  end

  # GET /special_dates/new
  # GET /special_dates/new.xml
  def new
    if params[:edit_date]
      week_of = Date.parse( params[:edit_date] )
      @special_date = @congregation.special_dates.where( :week_of => week_of ).first
      if @special_date
        redirect_to edit_congregation_special_date_path( @congregation, @special_date )
        return
      else
        @special_date = SpecialDate.new( :week_of => week_of )
      end
    else
      flash[:error] = "The week of the special date must be passed as a parameter."
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @special_date }
    end
  end

  # GET /special_dates/1/edit
  def edit
    @special_date = @congregation.special_dates.find( params[:id] )
  end

  # POST /special_dates
  # POST /special_dates.xml
  def create
    @special_date = @congregation.special_dates.build( params[:special_date] )

    respond_to do |format|
      if @special_date.save
        format.html { redirect_to( [@congregation, @special_date], :notice => t("flash.actions.create.notice", :model => SpecialDate.model_name.human)) }
        format.xml  { render :xml => @special_date, :status => :created, :location => @special_date }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @special_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /special_dates/1
  # PUT /special_dates/1.xml
  def update
    @special_date = @congregation.special_dates.find( params[:id] )

    respond_to do |format|
      if @special_date.update_attributes( params[:special_date] )
        format.html { redirect_to( [@congregation, @special_date], :notice => t("flash.actions.update.notice", :model => SpecialDate.model_name.human)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @special_date.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /special_dates/1
  # DELETE /special_dates/1.xml
  def destroy
    @special_date = @congregation.special_dates.find( params[:id] )
    @special_date.destroy

    respond_to do |format|
      format.html { redirect_to(congregation_special_dates_path(@congregation), :notice => t("flash.actions.destroy.notice", :model => SpecialDate.model_name.human)) }
      format.xml  { head :ok }
    end
  end

  def update_calendar
    respond_to do | format |  
        format.js {render :layout => false}  
    end
  end

  private

  def prepare_calendar
    if params[:calendar_date]
      @calendar_date = Date.parse( params[ :calendar_date ] )
    elsif params[:id]
      @special_date = @congregation.special_dates.find( params[:id] )
      @calendar_date = @special_date.week_of
    else
      @calendar_date = Date.today
    end
    @calendar_date = Date.civil( @calendar_date.year, @calendar_date.month, 1 )
    @selected_week = Date.parse( params[:selected_week] ) if params[:selected_week]
  end

end
