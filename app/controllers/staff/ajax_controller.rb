class Staff::AjaxController < Staff::Base
  before_action :staff_member_check

  # GET
  def message_count
    render plain: CustomerMessage.unprocessed.count
    #render plain: "100"
  end

end
