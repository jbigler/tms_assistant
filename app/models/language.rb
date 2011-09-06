class Language < ActiveRecord::Base

  has_many :schedules, :autosave => true, :dependent => :destroy
  has_many :lesson_sources, :autosave => true, :dependent => :delete_all
  has_many :setting_sources, :autosave => true, :dependent => :delete_all
  has_many :congregations

  attr_accessible :name, :display_name, :code
  validates_presence_of :name

  after_save :create_associated_records

  private

  def create_associated_records
    if lesson_sources.empty?
      LESSON_SOURCES_COUNT.times do |i|
        chapter = i + 1
        lesson_source = self.lesson_sources.build
        lesson_source.chapter = chapter
        lesson_source.use_for_reading = true if READING_LESSONS.include?( chapter )
        lesson_source.use_for_demonstration = true if DEMONSTRATION_LESSONS.include?( chapter )
        lesson_source.use_for_discourse = true if DISCOURSE_LESSONS.include?( chapter )
      end
      self.save
    end

    if setting_sources.empty?
      SETTING_SOURCES_COUNT.times do |i|
        number = i + 1
        setting_source = self.setting_sources.build
        setting_source.number = number
      end
      self.save
    end
  end

end

# == Schema Information
#
# Table name: languages
#
#  id           :integer         primary key
#  name         :string(50)      not null
#  display_name :string(50)
#  code         :string(10)
#  created_at   :timestamp
#  updated_at   :timestamp
#

