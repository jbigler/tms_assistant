class AddHasReviewToSchoolSessions < ActiveRecord::Migration
  def change
    add_column :school_sessions, :has_review, :boolean, :default => false
  end
end
