class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :task
      t.text :name
      t.text :file

      t.timestamps
    end
  end
end
