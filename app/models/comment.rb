class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :flaggings, as: :flaggable

  validates :content, :post_id, presence: true

  before_create{ generate_author_name }

  def update_flagged_count
    self.update_attribute(:flagged, self.flaggings.count)
  end

    private

  def generate_author_name
    if by_post_author?
      self.author_name = "Author"
    else
      siblings = get_comment_siblings
      self.author_name = find_previous_name(siblings) || find_unused_name(siblings)
    end
  end

  def by_post_author?
    self.post.session_id == self.session_id
  end

  def get_comment_siblings
    post_id ? Comment.where(post_id: post_id) : []
  end

  def find_previous_name(siblings)
    siblings.each do |sib|
      return sib.author_name if sib.session_id == self.session_id
    end
    nil
  end

  def find_unused_name(siblings)
    names = ["Beech", "Birch", "Chestnut", "Dogwood", "Elm", 
             "Hickory", "Magnolia", "Maple", "Oak", "Poplar",
             "Sassafras", "Sweetgum", "Sycamore", "Willow"]

    name_wrap = (siblings.count + 1) / names.count

    if name_wrap > 0
      add_on = (name_wrap + 1).to_s
      names.each_index { |i| names[i] += add_on }
    end

    sib_names = siblings.map { |sib| sib.author_name }
    sib_names.each do |name|
      if name_wrap > 0
        names.delete(name) if name =~ /[^z#{add_on}]/
      else
        names.delete(name)
      end
    end

    names.sample
  end

end
