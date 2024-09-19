class Participant < ApplicationRecord
  belongs_to :group_form, class_name: 'GroupForm', foreign_key: 'group_id'
  validates :name, :last_name, :birth_date, :age, presence: true

  has_one_attached :photo
  has_one_attached :file
  has_one_attached :id_card
end
