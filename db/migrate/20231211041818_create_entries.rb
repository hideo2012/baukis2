class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.references :program, null: false, index: false
      t.references :customer, null: false
      t.boolean :approved, null: false, default: false  # 承認済
      t.boolean :canceled, null: false, default: false  # 取消済


      t.timestamps
    end
  end
end
