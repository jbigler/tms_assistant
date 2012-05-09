class FamiliesController < ApplicationController

  before_filter :require_congregation

  def index
    @families = @congregation.families.order( "name" )

    respond_to do |format|
      format.html
      format.xml  { render :xml => @families }
    end
  end

  def show
    @family = @congregation.families.find( params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @family }
    end
  end

  def new
    @family = @congregation.families.build

    respond_to do |format|
      format.html
      format.xml  { render :xml => @family }
    end
  end

  def create
    family = @congregation.families.create( params[:family] )

    respond_to do |format|
      if family.save
        format.html { redirect_to( [@congregation, family], :notice => 'Student was successfully created.') }
        format.xml  { render :xml => family, :status => :created, :location => family }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => family.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @family = @congregation.families.find( params[:id] )

    respond_to do |format|
      format.html
      format.xml  { render :xml => @family }
    end
  end

  def update
    @family = @congregation.families.find( params[:id] )

    respond_to do |format|
      if @family.update_attributes( params[:family] )
        format.html { redirect_to( [@congregation, @family], :notice => 'Family was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @family = @congregation.families.find( params[:id] )
    @family.destroy

    respond_to do |format|
      format.html { redirect_to( congregation_families_path( @congregation ) ) }
      format.xml  { head :ok }
    end
  end
end
