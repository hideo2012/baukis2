class Staff::AjaxController < Staff::Base
  before_action :staff_member_check
  before_action :reject_non_xhr

  # GET
  def message_count
    render plain: CustomerMessage.unprocessed.count
    #render plain: "100"
  end

  # POST
  def add_tag
    message = Message.find( params[:id] )
    message.add_tag( params[:label] )
    render plain: "ok"
  end

  # DELETE
  def remove_tag
    message = Message.find( params[:id] )
    message.remove_tag( params[:label] )
    render plain: "ok"
  end

end
