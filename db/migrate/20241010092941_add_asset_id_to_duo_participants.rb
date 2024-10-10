class AddAssetIdToDuoParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :duo_participants, :asset_id, :string
  end
end
