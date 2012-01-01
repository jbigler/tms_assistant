module SchoolSessionHelper

  def prepare_lesson_select( lessons )
    lessons.all.collect do |lesson|
      if lesson.date_completed
        [lesson.chapter.to_s + " - " + lesson.description + " Date Completed: " + lesson.date_completed, lesson.chapter]
      elsif lesson.date_started
        [lesson.chapter.to_s + " - " + lesson.description + " Date Started: " + lesson.date_started, lesson.chapter]
      else
        [lesson.chapter.to_s + " - " + lesson.description, lesson.chapter]
      end
    end
  end

  def prepare_setting_select( settings )
    settings.all.collect do |setting|
      if setting.last_used
        [setting.number.to_s + setting.description[0,20] + " Last Used: " + setting.last_used, setting.number]
      else
        [setting.number.to_s + setting.description[0,20], setting.number]
      end
    end
  end

  def select_eligible_students( assignment )
    assignment.select( :student_id, assignment.object.find_eligible_students.collect {|i| [i.display_name + " - Last Assignment: " + i.latest_date.to_s + " - School: " + i.school_no.to_s, i.id] }, { :include_blank => true } )
  end

  def select_eligible_assistants( assignment )
    assignment.select( :assistant_id,
                      assignment.object.find_eligible_assistants.collect { |i|
      [i.display_name + " - Last Used: " + i.latest_date.to_s + 
        " - With: " + i.last_assisted_name.to_s, i.id] },
        { :include_blank => true } )
  end
end
