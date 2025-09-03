class AddUserIdToProfessors < ActiveRecord::Migration[7.1]
  def change
    add_reference :professors, :user, null: false, foreign_key: true
  end
end
