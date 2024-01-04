class CustomerMessage < Message
  scope :unprocessed, ->{ where(status: "new", deleted: false ) }

  def self.number_of_unprocessed_message
    count = self.unprocessed.count
    count > 0 ? "(#{count})" : ""
  end

  def type_memo
    "  問い合わせ "
  end

  def sender
    customer.full_name
  end
  
  def receiver
    ""
  end
end
