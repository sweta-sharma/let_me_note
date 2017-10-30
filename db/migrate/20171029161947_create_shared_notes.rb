class CreateSharedNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :shared_notes, id: false do |t|
      t.references :note
      t.references :user
      t.string :permission
      t.timestamps
    end
  end
end
