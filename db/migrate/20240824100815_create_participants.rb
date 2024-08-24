class CreateParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :last_name
      t.date :birth_date
      t.integer :age
      t.bigint :group_id

      t.timestamps
    end
  end
end
