class Duo < ApplicationRecord
  belongs_to :user
  has_many :duo_participants, inverse_of: :duo, dependent: :destroy
  accepts_nested_attributes_for :duo_participants, allow_destroy: true

  validates :name, :responsable, :address, :phone, :email, :discipline, :level,
            :title_of_music, :composer, :length_of_piece, presence: true
  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire', 'Moyen', 'Supérieur', 'Formation'] }
  validates :discipline, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain', 'Caractère'] }
end
