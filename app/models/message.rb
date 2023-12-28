class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :staf_member, optional: true
  belongs_to :root, class_name: "Message", foreign_key: "root_id", optional: true
  belongs_to :parent, class_name: "Message", foreign_key: "parent_id", optional: true

  before_validation do
    if parent
      self.customer = parent.customer
      self.root = parent.root || parent
    end
  end

  validates :subject, presence: true, length: { maximum: 80 }
  validates :body, presence: true, length: { maximum: 800 }
end


=begin
      t.string :subject, null: false
      t.text :body
      t.text :remarks # 備考 for staff

      t.references :customer, null: false
      t.references :staff_member

      t.integer :root_id # forign key for Message
      t.integer :parent_id # forign key for Message
      t.string :type, null: false # inheritance
      t.string :status, null: false, default: "new" # for staff
      t.boolean :discarded, null: false, default: false # for customer
      t.boolean :deleted, null: false, default: false # for staff
=end


