class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :title
      t.references :genre, null: false, foreign_key: true
      t.references :platform, null: false, foreign_key: true

      t.timestamps
    end
  end
end
