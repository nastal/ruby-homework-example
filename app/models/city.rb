class City < ApplicationRecord
  has_many :hotels

  def self.find_by_case_insensitive(attribute, value)
    where("LOWER(#{attribute}) = ?", value.downcase).first
  end
end
