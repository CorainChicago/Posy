class Flagging < ActiveRecord::Base
  belongs_to :flaggable, polymorphic: true

  validates_uniqueness_of :session_id, scope: [:flaggable_id, :flaggable_type]

  after_create { self.flaggable.update_flagged_count }

end
