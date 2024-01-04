class Staff::RepliesController < Staff::Base
  before_action :staff_member_check
  before_action :prepare_message

  def new
    @reply = StaffMessage.new
  end

  def confirm
    @reply = StaffMessage.new( strong_params )
    @reply.staff_member = current_staff_member
    @reply.parent = @message
    if @reply.invalid?
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  def create
    @reply = StaffMessage.new( strong_params )
    @reply.staff_member = current_staff_member
    @reply.parent = @message
    if params[:correct]
      render action: "new"
      return
    end
    if @reply.save
      flash.notice = " 問い合わせに返信しました。 "
      redirect_to :outbound_staff_messages
    else
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  private def prepare_message
    @message = CustomerMessage.find( params[ :message_id ] )
  end

  private def strong_params
    params.require(:staff_message).permit(:subject, :body)
  end
end
