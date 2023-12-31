class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :customer, null: false
      t.references :staff_member
      t.integer :root_id # forign key for Message
      t.integer :parent_id # forign key for Message
      t.string :type, null: false # inheritance
      t.string :status, null: false, default: "new" # for staff
      t.string :subject, null: false
      t.text :body
      t.text :remarks # 備考 for staff
      t.boolean :discarded, null: false, default: false # for customer
      t.boolean :deleted, null: false, default: false # for staff

      t.timestamps
    end

    add_index :messages, [ :type, :customer_id  ]
    add_index :messages, [ :customer_id, :discarded, :created_at ]
    add_index :messages, [ :type, :staff_member_id  ]
    add_index :messages, [ :customer_id, :deleted, :created_at ]
    add_index :messages, [ :customer_id, :deleted, :status, :created_at ],
      name: "index_messages_on_c_d_s_c"
    add_index :messages, [ :root_id, :deleted, :created_at ]

    add_foreign_key :messages, :customers
    add_foreign_key :messages, :staff_members
    add_foreign_key :messages, :messages, column: "root_id"
    add_foreign_key :messages, :messages, column: "parent_id"
  end
end
