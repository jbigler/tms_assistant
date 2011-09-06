require 'spec_helper'

describe LessonHistory do

  it { should belong_to( :lesson ) }
  it { should validate_presence_of( :lesson_id ) }
  it { should validate_presence_of( :assignment_date ) }

end
