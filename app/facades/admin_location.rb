class AdminLocation
  attr_reader :location

  def initialize(location)
    @location = location
  end

  def posts
    @posts ||= location.posts.order(:created_at => :desc)
  end

  def priorities
    @priorities ||= posts.select do |post|
      post.admin_priority? || post.has_priority_comment?
    end
  end

end