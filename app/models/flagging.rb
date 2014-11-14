class Flagging < ActiveRecord::Base
  belongs_to :flaggable, polymorphic: true

  validates_uniqueness_of :session_id, scope: [:flaggable_id, :flaggable_type]

  after_create { self.flaggable.update_flagged_count }

  def self.retreive_flagged_content(session_id)
    flaggings = self.where(session_id: session_id)
    flagged_ids = { posts: [], comments: [] }

    # This enumeration is intended to reduce database queries to just one;
    # these items may already be loaded into memory though, so I am unsure if
    # enumeration is actually faster than multiple ActiveRecord expressions.
    flaggings.each do |flagging|
      if flagging.flaggable_type == "Post"
        flagged_ids[:posts] << flagging.flaggable_id
      elsif flagging.flaggable_type == "Comment"
        flagged_ids[:comments] << flagging.flaggable_id
      end
    end

    flagged_ids
  end

end
