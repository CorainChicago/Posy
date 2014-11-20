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
    flags = self.flaggings.count

    if flags >= FLAGGED_THRESHOLD
      self.update_attributes(flagged: flags, status: STATES[:flagged])
    else
      self.update_attribute(:flagged, self.flaggings.count)
    end
  end

  def admin_priority?
    self.status == STATES[:flagged]
  end

end