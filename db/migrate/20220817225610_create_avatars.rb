class CreateAvatars < ActiveRecord::Migration[6.1]
  def change
    create_table :avatars do |t|
      t.string :icon
      t.belongs_to :member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
