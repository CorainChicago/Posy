class Comment < ActiveRecord::Base
  include Content

  belongs_to :post
  has_many :flaggings, as: :flaggable
  
  default_scope { order("created_at ASC") }

  validates :content, :post_id, presence: true

  before_create :generate_author_name

  NAMES = ["Beech", "Birch", "Chestnut", "Dogwood", "Elm", 
           "Hickory", "Magnolia", "Maple", "Oak", "Poplar",
           "Sassafras", "Sweetgum", "Sycamore", "Willow"]

  def generate_author_name
    if by_post_author?
      self.author_name ||= "Author"
    else
      self.author_name ||= find_previous_name || find_unused_name
    end
  end

    private

  def by_post_author?
    post.session_id == session_id && session_id != nil
  end

  def siblings
    @siblings ||= post_id ? self.class.where(post_id: post_id) : []
  end

  def sibling_names
    @sibling_names ||= siblings.pluck(:author_name).uniq
  end

  def find_previous_name
    return nil if session_id.nil?
    siblings.each do |sib|
      return sib.author_name if sib.session_id == session_id
    end
    nil
  end

  def find_unused_name
    possible_names.sample
  end

  def possible_names
    wrap_amount = calculate_name_wrap
    names = wrap_amount > 0 ? apply_name_wrap(wrap_amount) : NAMES
    names - sibling_names
  end

  def calculate_name_wrap
    name_count = sibling_names.count
    (name_count + 1) / NAMES.count
  end

  def apply_name_wrap(n)
    NAMES.map { |name| name + n.to_s }
  end

end
