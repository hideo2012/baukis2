class CreateMsgTagLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :msg_tag_links do |t|
      t.references :message, null: false
      t.references :tag, null: false

      t.timestamps
    end

    add_index :msg_tag_links, [ :message_id, :tag_id ], unique: true
  end
end
