class CreateDuos < ActiveRecord::Migration[7.1]
  def change
    create_table :duos do |t|
      t.string :name
      t.string :responsable
      t.string :address
      t.string :phone
      t.string :email
      t.string :discipline
      t.string :level
      t.string :title_of_music
      t.string :composer
      t.string :length_of_piece
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
