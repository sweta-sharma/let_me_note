class CreateSharedNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :shared_notes do |t|
      t.references :note
      t.references :user
      t.integer :permission, default: 0
      t.timestamps
    end
  end
end
