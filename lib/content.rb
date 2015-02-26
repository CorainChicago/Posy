module Content
  # created to be implemented by models for user-generated
  # content (i.e. posts, comments)

  FLAGGED_THRESHOLD = 2
  STATES = {
    cleared: 1,  # marked as OK by admin
    default: 0,  # untouched by admin, flaggings below threshold
    flagged: -1, # number of flaggings above threshold
    removed: -2  # removed by admin
  }

  def clear?
    self.status >= 0
  end

  def mark_as_cleared
    self.update_attribute(:status, STATES[:cleared])
  end

  def mark_as_removed
    self.update_attribute(:status, STATES[:removed])
  end

  def update_flagged_count
    self.flagged = flaggings.count
    check_against_threshold
    save
  end

  def admin_priority?
    self.status == STATES[:flagged]
  end

    private

  def check_against_threshold
    if self.flagged >= FLAGGED_THRESHOLD
      self.status = STATES[:flagged]
    end
  end

end