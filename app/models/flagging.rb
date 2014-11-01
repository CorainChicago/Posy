class Flagging < ActiveRecord::Base
  belongs_to :flaggable, polymorphic: true

  after_create { self.flaggable.update_flagged_count }

end
