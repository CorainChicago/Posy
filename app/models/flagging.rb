class Flagging < ActiveRecord::Base
  belongs_to :flaggable, polymorphic: true

  validates_uniqueness_of :session_id, scope: [:flaggable_id, :flaggable_type]

  after_create :notify_owner

  def self.flagged_by_session(session_id)
    self.where(session_id: session_id)
  end

  def self.comments_flagged_by_session(session_id)
    flagged_by_session(session_id).where(flaggable_type: Comment)
  end

  def self.posts_flagged_by_session(session_id)
    flagged_by_session(session_id).where(flaggable_type: Post)
  end

  def notify_owner
    flaggable.update_flagged_count
  end
  
end
