class ReportsController < ApplicationController

  before_filter :authenticate_user!, :require_congregation

  def show
    @report = Report.new("assignment_slips", @congregation, params)

    #TODO Validate that the report is valid, if not flash an error

    respond_to do |format|
      format.pdf do
        send_data @report.pdf, :filename => "assignment_slips.pdf", 
                          :type => "application/pdf",
                          :disposition => 'inline'
      end
    end
  end
end
