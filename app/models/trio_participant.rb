class TrioParticipant < ApplicationRecord
  belongs_to :trio, class_name: 'Trio', foreign_key: 'trio_id'

  has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card

  validates :name, :last_name, :birth_date, :age, :photo, :file, :id_card, presence: true

end
