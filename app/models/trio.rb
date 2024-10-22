class Trio < ApplicationRecord
  belongs_to :user

  has_many :trio_participants, inverse_of: :trio, dependent: :destroy

  accepts_nested_attributes_for :trio_participants, allow_destroy: true

  validates :name, :responsable, :address, :phone, :email, :discipline, :level,
            :title_of_music, :composer, :length_of_piece, presence: true

  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire', 'Moyen', 'Supérieur', 'Formation'] }
  validates :discipline, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain', 'Caractère'] }

  scope :by_style, ->(styles) { where(discipline: styles) if styles.present? }
  scope :by_level, ->(levels) { where(level: levels) if levels.present? }
  scope :after_date, ->(start_date) { where("created_at >= ?", start_date) if start_date.present? }

end
