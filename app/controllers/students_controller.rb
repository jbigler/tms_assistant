class StudentsController < ApplicationController

  before_filter :require_congregation
  before_filter :validate_student_type, :only => [:new]

  # GET /students
  # GET /students.xml
  def index
    @students = @congregation.students.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/new
  # GET /students/new.xml
  def new
    if params[:type] == "Brother"
      @student = Brother.new
    elsif params[:type] == "Sister"
      @student = Sister.new
    else
      redirect_to congregation_students_path( @congregation )
      return
    end

    if params[:family]
      @student.family = @congregation.families.find( params[:family] )
    end

    @families = families

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # GET /students/1/edit
  def edit
    @student = @congregation.students.find(params[:id])
    @families = families

    respond_to do |format|
      format.html
      format.xml  { render :xml => @student }
    end
  end

  # POST /students
  # POST /students.xml
  def create
    if params[:student_type]
      case params[:student_type]
      when "brother"
        @student = Brother.new( params[:student] )
      when "sister"
        @student = Sister.new( params[:student] )
      end
    else
      flash[:error] = t "flash.actions.create.error", :model => Student.model_name.human
      redirect_to congregation_students_url( @congregation )
      return
    end

    if params[:new_family]
      family = @congregation.families.create( :name => @student.last_name ) 
      @student.family = family
    end

    @student.congregation = @congregation

    respond_to do |format|
      if @student.save
        format.html { redirect_to congregation_student_path( @congregation, @student ), :notice => t("flash.actions.create.notice", :model => Student.model_name.human) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { redirect_to :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = @congregation.students.find( params[:id] )
    @families = families

    if params[:new_family] == "1"
      family = @congregation.families.create( :name => @student.last_name )
      @student.family = family
    end

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to congregation_student_path( @congregation, @student ), :notice => t("flash.actions.create.notice", :model => Student.model_name.human) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = @congregation.students.find( params[:id] )
    @student.destroy

    respond_to do |format|
      format.html { redirect_to( congregation_students_path( @congregation ) ) }
      format.xml  { head :ok }
    end
  end

  private

  def validate_student_type
    if not params[:type]
      flash[:alert] = t "flash.invalid_parameters"
      redirect_to :back
    end
  end

  def families
    if @congregation.families then
      @congregation.families.order( "name" ).collect do |family|
        [family.name + " (" + family.first_name + ")", family.id]
      end
    else
      []
    end
  end

end
