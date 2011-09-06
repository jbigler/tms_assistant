require 'spec_helper'

describe Lesson do

  it { should belong_to( :lesson_source ) }
  it { should belong_to( :student ) }
  it { should have_many( :assignments ) }
  it { should have_many( :lesson_histories ) }

  it { should validate_presence_of ( :lesson_source_id ) }
  it { should validate_presence_of ( :student_id ) }

end
