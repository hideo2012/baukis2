class Staff::AjaxController < Staff::Base
  before_action :staff_check

  # GET
  def message_count
    render plain: CustomerMessage.unprocessed.count
  end



end
