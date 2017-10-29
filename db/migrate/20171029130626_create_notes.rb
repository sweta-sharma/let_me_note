class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :content, default: '', null: false
      t.references :user
      t.timestamps
    end
  end
end
