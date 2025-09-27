class IndividualForm < ApplicationRecord
  belongs_to :user
  after_create :send_submission_email

  # has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card

  validates :first_name, :last_name, :birth_date, :address, :phone, :email,
            :teacher_name, :dance_school, :teacher_phone, :teacher_email,
            :category, :style, :level, :file, :id_card, presence: true
            # :category, :style, :level, :photo, :file, :id_card, presence: true

  validates :category, presence: true, inclusion: { in: ['Loisir', 'Pré-professionnelle'] }
  validates :style, presence: true, inclusion: { in: ['Classique', 'Modern’Jazz', 'Contemporain'] }
  validates :level, presence: true, inclusion: { in: ['Préparatoire', 'Élémentaire 1', 'Élémentaire 2', 'Élémentaire 2 – Répertoire', 'Moyen', 'Moyen - Répertoire', 'Avancée', 'Supérieur', 'Interprète'] }

  validate :attachments_size_within_limit

  scope :by_category, ->(categories) { where(category: categories) if categories.present? }
  scope :by_style, ->(styles) { where(style: styles) if styles.present? }
  scope :by_level, ->(levels) { where(level: levels) if levels.present? }
  scope :after_date, ->(start_date) { where("created_at >= ?", start_date) if start_date.present? }

  private

  def attachments_size_within_limit
    max_size_mb = 5

    if file.attached? && file.blob.byte_size > max_size_mb.megabytes
      errors.add(:file, "La taille du fichier joint ne doit pas dépasser #{max_size_mb} Mo.")
    end

    if id_card.attached? && id_card.blob.byte_size > max_size_mb.megabytes
      errors.add(:id_card, "La taille de la pièce d'identité jointe ne doit pas dépasser #{max_size_mb} Mo.")
    end

    # Uncomment this if you start using :photo
    # if photo.attached? && photo.blob.byte_size > max_size_mb.megabytes
    #   errors.add(:photo, "La taille de la photo ne doit pas dépasser #{max_size_mb} Mo.")
    # end
  end

  def send_submission_email
    FormSubmissionMailer.solo_submission(self).deliver_later
  rescue StandardError => e
    Rails.logger.error "Failed to send submission email for form ID #{id}: #{e.message}"
  end
end
