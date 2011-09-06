class ReportsController < ApplicationController

  before_filter :authenticate_user!, :require_congregation

  def show
    I18n.locale = @congregation.language.code
    week_of = Date.parse( params[:week_of] )
    assignments = []
    school_session = @congregation.school_sessions.find_by_week_of( week_of )

    unless school_session.cancelled?
      assignments << school_session.bible_highlights if school_session.bible_highlights.assigned?
      school_session.schools.each do |school|
        unless school.cancelled?
          assignments << school.talk_no1 if school.talk_no1.assigned?
          assignments << school.talk_no2 if school.talk_no2.assigned?
          assignments << school.talk_no3 if school.talk_no3.assigned?
        end
      end
    end

    output = AssignmentSlipReport.new( assignments, @congregation.meeting_day ).to_pdf

    respond_to do |format|
      format.pdf do
        send_data output, :filename => "assignment_slips.pdf", 
                          :type => "application/pdf",
                          :disposition => 'inline'
      end
    end
  end
end
