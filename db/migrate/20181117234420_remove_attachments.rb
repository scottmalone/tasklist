class RemoveAttachments < ActiveRecord::Migration[5.2]
  def up 
    drop_table :attachments
  end

  def down 
    create_table :attachments do |t|
      t.references :task
      t.text :name
      t.text :file

      t.timestamps
    end
  end
end
