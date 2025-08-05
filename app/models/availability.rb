class Availability < ApplicationRecord
  belongs_to :user
  
  validates :notes, presence: true

end
