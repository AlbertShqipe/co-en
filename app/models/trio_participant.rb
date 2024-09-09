class TrioParticipant < ApplicationRecord
  belongs_to :trio, class_name: 'Trio', foreign_key: 'trio_id'
  validates :name, :last_name, :birth_date, :age, presence: true

  has_one_attached :photo
  has_many_attached :files
end
