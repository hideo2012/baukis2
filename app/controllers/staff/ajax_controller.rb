class Staff::AjaxController < Staff::Base
  before_action :staff_member_check
  before_action :reject_non_xhr

  # GET
  def message_count
    render plain: CustomerMessage.unprocessed.count
    #render plain: "100"
  end

end
