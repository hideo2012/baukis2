class Message < ApplicationRecord
  belongs_to :customer
  belongs_to :staff_member, optional: true
  belongs_to :root, class_name: "Message", foreign_key: "root_id", optional: true
  belongs_to :parent, class_name: "Message", foreign_key: "parent_id", optional: true
  has_many :children, class_name: "Message", foreign_key: "parent_id", dependent: :destroy
  has_many :msg_tag_links, dependent: :destroy
  has_many :tags , -> { order(:value)  }, through: :msg_tag_links

  before_validation do
    if parent
      self.customer = parent.customer
      self.root = parent.root || parent
    end
  end

  validates :subject, presence: true, length: { maximum: 80 }
  validates :body, presence: true, length: { maximum: 800 }

  scope :not_deleted, -> { where( deleted: false ) }
  scope :deleted, -> { where( deleted: true ) }
  scope :sorted, -> { order( created_at: :desc ) }
  scope :tagged_as, -> ( tag_id ) do
    if tag_id
      joins(:msg_tag_links)
        .where( "msg_tag_links.tag_id" => tag_id )
    else
      self
    end
  end

  def add_tag( label )
    self.class.transaction do
      tag = Tag.find_by( value: label ) 
      tag ||= Tag.create!( value: label ) 
      unless msg_tag_links.where( tag_id: tag.id ).exists?
        msg_tag_links.create!( tag_id: tag.id )
      end
    end
  end

  def remove_tag( label )
    self.class.transaction do
      if tag = Tag.find_by( value: label ) 
        msg_tag_links.find_by( tag_id: tag.id ).destroy
        tag.destroy if tag.msg_tag_links.empty?
      end
    end
  end

  def root_message
    root ? root : self
  end

  def type_memo
    "  問い合わせ（返信）" 
    #raise
  end

  def sender
    " ( unknown )  "
  end

  def receiver
    " ( unknown )  "
  end

  def create_datetime
    if created_at > Time.current.midnight
      return created_at.strftime("%H:%M:%S")
    end
    if created_at > 5.months.ago.beginning_of_month
      return created_at.strftime("%m/%d %H:%M")
    end
    created_at.strftime("%Y/%m/%d %H:%M")
  end

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


