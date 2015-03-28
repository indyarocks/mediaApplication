class CreateMedias < ActiveRecord::Migration
  def change
    create_table :medias do |t|
      t.references :user, index: true
      t.string :url
      t.string :description
      t.integer :permission, default: 0

      t.timestamps null: false
    end
    add_foreign_key :medias, :users
  end
end
