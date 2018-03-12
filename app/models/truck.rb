class Truck < ActiveRecord::Base
  # todo has_many :items
  belongs_to :user

  validates :name, presence: true
end
