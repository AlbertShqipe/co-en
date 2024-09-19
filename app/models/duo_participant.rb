class DuoParticipant < ApplicationRecord
  belongs_to :duo, class_name: 'Duo', foreign_key: 'duo_id'
  has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card
  validates :name, :last_name, :birth_date, :age, presence: true

end
