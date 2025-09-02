class Professor < ApplicationRecord
  validates :first_name, :last_name, :school, presence: true
end
