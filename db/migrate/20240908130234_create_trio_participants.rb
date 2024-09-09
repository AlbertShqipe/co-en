class CreateTrioParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :trio_participants do |t|
      t.string :name
      t.string :last_name
      t.date :birth_date
      t.integer :age
      t.bigint :trio_id, null: true
      t.timestamps
    end
  end
end
