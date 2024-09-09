class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :individual_forms, dependent: :destroy
  has_many :group_forms, dependent: :destroy
  has_many :duos, dependent: :destroy
  has_many :trios, dependent: :destroy

  enum role: { admin: 0, competitor: 1, jury: 2 }
end
