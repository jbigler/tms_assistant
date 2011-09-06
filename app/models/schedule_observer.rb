class ScheduleObserver < ActiveRecord::Observer

  # If the has_review attribute of a schedule is changed,
  # destroy any SchoolSessions created for that date

  def after_save( schedule )
    if schedule.has_review_changed?
      congregations = Congregation.where( :language_id => schedule.language.id ).map( &:id )

      SchoolSession.where( :week_of => schedule.week_of ).
        where( :congregation_id => congregations ).destroy_all
    end
  end
end
