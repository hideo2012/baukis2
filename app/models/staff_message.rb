class StaffMessage < Message

  def type_memo
    "  返信 "
  end

  def sender
    staff_member.full_name
  end

  def receiver
    customer.full_name
  end
end
