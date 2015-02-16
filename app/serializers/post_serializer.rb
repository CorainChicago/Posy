class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :gender, :hair, :spotted_at, :age, :description

  has_many :comments

  def age
    minute = 60; hour = 60 * 60; day = hour * 24
    @time ||= Time.now
    seconds = (@time - object.created_at).to_i

    if (days = seconds / day) > 0
      return (days == 1 ? "#{days} day" : "#{days} days")
    elsif (hours = seconds / hour) > 0
      return (hours == 1 ? "#{hours} hour" : "#{hours} hours")
    elsif (minutes = seconds / minute) > 0
      return (minutes == 1 ? "#{minutes} minute" : "#{minutes} minutes")
    else
      return (seconds == 1 ? "#{seconds} second" : "#{seconds} seconds")
    end
  end

  def description
    object.gender = "" if object.gender == "other"
    object.hair = "" if object.hair == "other"

    if object.hair.present? && object.gender.present?
      return "#{object.gender}, #{translate_hair}"
    elsif object.hair.present?
      return translate_hair
    elsif object.gender.present?
      return object.gender
    else
      return ""
    end
  end

  def translate_hair
    hair_desc = { 
      "blonde" => "blonde",
      "black" => "black-haired",
      "brown" => "brunette",
      "red" => "redhead"
     }
     hair_desc[object.hair.downcase]
  end

end