class Participant < ApplicationRecord
  belongs_to :group

  validates :name, :last_name, :birth_date, :age, presence: true
end
