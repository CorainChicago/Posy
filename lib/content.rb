module Content
  # created to be implemented by models for user-generated
  # content (i.e. posts, comments)

  @@states = {
    cleared: 1,  # marked as OK by admin
    default: 0,  # untouched by admin, flaggings below threshold
    flagged: -1, # number of flaggings above threshold
    removed: -2  # removed by admin
  }

  def clear?
    self.status >= 0
  end

  def mark_as_cleared
    self.update_attribute(:status, @@states[:cleared])
  end

  def mark_as_removed
    self.update_attribute(:status, @@states[:removed])
  end

  def mark_as_flagged
    self.update_attribute(:status, @@state[:flagged])
  end

  def update_flagged_count
    self.update_attribute(:flagged, self.flaggings.count)
  end

end