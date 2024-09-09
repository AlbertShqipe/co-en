class CreateDuoParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :duo_participants do |t|
      t.string :name
      t.string :last_name
      t.date :birth_date
      t.integer :age
      t.bigint :duo_id, null: true

      t.timestamps
    end
  end
end
