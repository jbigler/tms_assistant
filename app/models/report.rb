class Report
  attr_reader :name, :options

  def initialize(name, congregation, options)
    @name = name
    @congregation = congregation
    @options = options || {}
  end

  def pdf
    I18n.locale = @congregation.language.code
    week_of = Date.parse( @options[:week_of] )
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
  end
end
