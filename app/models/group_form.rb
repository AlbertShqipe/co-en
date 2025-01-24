class GroupForm < ApplicationRecord
  belongs_to :user
  after_create :send_submission_email

  has_many :participants, inverse_of: :group_form, dependent: :destroy

  accepts_nested_attributes_for :participants, allow_destroy: true

  validates :name, :responsable, :address, :phone, :email, :discipline, :level,
            :title_of_music, :composer, :length_of_piece, presence: true

  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire', 'Moyen', 'Supérieur', 'Formation'] }
  validates :discipline, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain', 'Caractère'] }

  scope :by_discipline, ->(disciplines) { where(discipline: disciplines) if disciplines.present? }
  scope :by_level, ->(levels) { where(level: levels) if levels.present? }
  scope :after_date, ->(start_date) { where("created_at >= ?", start_date) if start_date.present? }

  private

  def send_submission_email
    FormSubmissionMailer.group_submission(self).deliver_later
  rescue StandardError => e
    Rails.logger.error "Failed to send submission email for form ID #{id}: #{e.message}"
  end
end
