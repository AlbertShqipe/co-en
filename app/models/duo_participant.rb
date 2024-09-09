class DuoParticipant < ApplicationRecord
  belongs_to :duo, class_name: 'Duo', foreign_key: 'duo_id'
  validates :name, :last_name, :birth_date, :age, presence: true

  has_one_attached :photo
  has_many_attached :files
end
