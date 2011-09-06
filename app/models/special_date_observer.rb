class SpecialDateObserver < ActiveRecord::Observer

  # When a SpecialDate is changed or deleted, delete
  # the corresponding SchoolSession.

  def before_save( special_date )
    congregation = special_date.congregation
    congregation.school_sessions.where( :week_of => special_date.week_of ).destroy_all
  end

  def after_destroy( special_date )
    congregation = special_date.congregation
    congregation.school_sessions.where( :week_of => special_date.week_of ).destroy_all
  end

end
