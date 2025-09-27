class TrioParticipant < ApplicationRecord
  belongs_to :trio, class_name: 'Trio', foreign_key: 'trio_id'

  # has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card

  # validates :name, :last_name, :birth_date, :age, :photo, :file, :id_card, presence: true
  validates :name, :last_name, :birth_date, :age, :file, :id_card, presence: true

  validate :attachments_size_within_limit

  private

  def attachments_size_within_limit
    max_size_mb = 5

    if file.attached? && file.blob.byte_size > max_size_mb.megabytes
      errors.add(:file, "La taille du fichier joint ne doit pas dépasser #{max_size_mb} Mo.")
    end

    if id_card.attached? && id_card.blob.byte_size > max_size_mb.megabytes
      errors.add(:id_card, "La taille de la pièce d'identité jointe ne doit pas dépasser #{max_size_mb} Mo.")
    end

    # Uncomment if using :photo
    # if photo.attached? && photo.blob.byte_size > max_size_mb.megabytes
    #   errors.add(:photo, "La taille de la photo ne doit pas dépasser #{max_size_mb} Mo.")
    # end
  end

end
