class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :email
      t.text :message
      t.timestamps
    end
  end
end
