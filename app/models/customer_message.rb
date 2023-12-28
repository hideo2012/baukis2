class CustomerMessage < Message
  scope :unprocessed, ->{ where(status: "new", deleted: false ) }


  def self.number_of_unprocessed_message
    count = self.unprocessed.count
    count > 0 ? "(#{count})" : ""
  end
end
