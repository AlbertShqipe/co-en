class Participant < ApplicationRecord
  belongs_to :group_form, class_name: 'GroupForm', foreign_key: 'group_id'

  # has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card

  validates :name, :last_name, :birth_date, :age, :file, :id_card, presence: true
  # validates :name, :last_name, :birth_date, :age, :photo, :file, :id_card, presence: true

end
