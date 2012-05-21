module SchoolSessionHelper

  def prepare_lesson_select( lessons )
    lessons.all.collect do |lesson|
      if lesson.date_completed
        [lesson.chapter.to_s + " - " + lesson.description + " - " +  Lesson.human_attribute_name("date_completed") + ": " + lesson.date_completed, lesson.chapter]
      elsif lesson.date_started
        [lesson.chapter.to_s + " - " + lesson.description + " - " +  Lesson.human_attribute_name("date_started") + ": " + lesson.date_started, lesson.chapter]
      else
        [lesson.chapter.to_s + " - " + lesson.description, lesson.chapter]
      end
    end
  end

  def prepare_setting_select( settings )
    settings.all.collect do |setting|
      if setting.last_used
        [setting.number.to_s + setting.description[0,20] + " " + Setting.human_attribute_name("last_used") + ": " + setting.last_used, setting.number]
      else
        [setting.number.to_s + setting.description[0,20], setting.number]
      end
    end
  end

  def select_eligible_students( assignment )
    assignment.select( :student_id, assignment.object.find_eligible_students.collect {|i| [fix_display_name(i) + " - " + t(".last_assignment") + i.latest_date.to_s + " - " + School.model_name.human + ": " + i.school_no.to_s, i.id] }, { :include_blank => true } )
  end

  def select_eligible_assistants( assignment )
    assignment.select( :assistant_id,
                      assignment.object.find_eligible_assistants.collect { |i|
      [fix_display_name(i) + " - " + t(".last_used") + i.latest_date.to_s + 
        " - " + t(".last_assisted") + i.last_assisted_name.to_s, i.id] },
        { :include_blank => true } )
  end

  def fix_display_name(record)
    if record.display_name == ""
      [record.first_name, record.last_name].join(" ")
    else
      record.display_name
    end
  end
end
