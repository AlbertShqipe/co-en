class CreateIndividualForms < ActiveRecord::Migration[7.1]
  def change
    create_table :individual_forms do |t|
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :address
      t.string :phone
      t.string :email
      t.string :teacher_name
      t.string :dance_school
      t.string :teacher_phone
      t.string :teacher_email
      t.string :category
      t.string :style
      t.string :level
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
