class CreateProfessors < ActiveRecord::Migration[7.1]
  def change
    create_table :professors do |t|
      t.string :first_name
      t.string :last_name
      t.string :school

      t.timestamps
    end
  end
end
