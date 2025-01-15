class IndividualForm < ApplicationRecord
  belongs_to :user
  # after_create :send_submission_email

  has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card

  validates :first_name, :last_name, :birth_date, :address, :phone, :email,
            :teacher_name, :dance_school, :teacher_phone, :teacher_email,
            :category, :style, :level, :photo, :file, :id_card, presence: true

  validates :category, presence: true, inclusion: { in: ['Loisir', 'Pré-professionnelle'] }
  validates :style, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain', 'Caractère'] }
  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Elémentaire 1', 'Elémentaire 2', 'Elémentaire 2B', 'Moyen', 'Moyen 1', 'Moyen 1B', 'Moyen 2', 'Avancée', 'Supérieur', 'Formation'] }

  scope :by_category, ->(categories) { where(category: categories) if categories.present? }
  scope :by_style, ->(styles) { where(style: styles) if styles.present? }
  scope :by_level, ->(levels) { where(level: levels) if levels.present? }
  scope :after_date, ->(start_date) { where("created_at >= ?", start_date) if start_date.present? }

  private

  def send_submission_email(self)
    FormSubmissionMailer.solo_form_submission(self).deliver_now
  rescue StandardError => e
    Rails.logger.error "Failed to send welcome email: #{e.message}"
  end
end
