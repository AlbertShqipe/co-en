class IndividualForm < ApplicationRecord
  belongs_to :user

  has_one_attached :photo
  has_one_attached :file

  validates :first_name, :last_name, :birth_date, :address, :phone, :email,
            :teacher_name, :dance_school, :teacher_phone, :teacher_email,
            :category, :style, :level, presence: true

  validates :category, presence: true, inclusion: { in: ['Loisir', 'Pré-professionnelle'] }
  validates :style, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain'] }
  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire 1', 'Elémentaire 2', 'Elémentaire 2B', 'Moyen', 'Moyen 1', 'Moyen 1B', 'Moyen 2', 'Avancée', 'Supérieur', 'Formation'] }
end
