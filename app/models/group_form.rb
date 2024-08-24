class GroupForm < ApplicationRecord
  belongs_to :user
  has_many :participants, inverse_of: :group, dependent: :destroy
  accepts_nested_attributes_for :participants, allow_destroy: true

  validates :name, :responsable, :address, :phone, :email, :discipline, :level,
            :title_of_music, :compositor, :length_of_piece, presence: true
  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire', 'Moyen', 'Supérieur', 'Formation'] }
  validates :discipline, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain'] }
end
