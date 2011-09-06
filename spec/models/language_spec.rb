require 'spec_helper'

describe Language do

  it { should have_many( :schedules ) }
  it { should have_many( :lesson_sources ) }
  it { should have_many( :setting_sources ) }
  it { should validate_presence_of( :name ) }

  it "should create LessonSources for a new Language" do
    expect {
      FactoryGirl.create( :language )
    }.to change{ LessonSource.count }.by( LESSON_SOURCES_COUNT )
  end

  it "should create SettingSources for a new Language" do
    expect {
      FactoryGirl.create( :language )
    }.to change{ SettingSource.count }.by( SETTING_SOURCES_COUNT )
  end
end
