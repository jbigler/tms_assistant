module Constants
  SCHEDULE_ASSIGNMENT_TYPES_REVIEW = ["BibleHighlights"]
  SCHEDULE_ASSIGNMENT_TYPES = SCHEDULE_ASSIGNMENT_TYPES_REVIEW + ["TalkNo1", "TalkNo2", "TalkNo3"]
  ALL_ASSIGNMENT_TYPES_REVIEW = SCHEDULE_ASSIGNMENT_TYPES_REVIEW + ["Reader"]
  SPECIAL_DATE_EVENTS = ["Circuit Assembly", "District Convention", "Special Assembly Day", "Circuit Overseer Visit", "Other"]
  LESSON_SOURCES_COUNT = 53
  SETTING_SOURCES_COUNT = 30
  READING_LESSONS = (1..17).to_a
  DEMONSTRATION_LESSONS = (1..6).to_a + (8..51).to_a
  DISCOURSE_LESSONS = (1..17).to_a + (19..29).to_a + (31..53).to_a
  COMPLETED_BY = ["student", "substitute"]
  LESSON_STATUS = ["complete", "incomplete"]
end
