class Customer::RepliesController < Customer::Base
  before_action :customer_check
  before_action :reply_source_staff_message

  def new
    @reply = CustomerMessage.new
  end

  def confirm
    @reply = CustomerMessage.new( strong_params )
    @reply.parent = @staff_message
    if @reply.invalid?
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  def create
    @reply = CustomerMessage.new( strong_params )
    @reply.parent = @staff_message
    if params[:correct]
      render action: "new"
      return
    end
    if @reply.save
      flash.notice = " メッセージに回答しました。 "
      redirect_to :customer_messages
    else
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  private def reply_source_staff_message
    @staff_message = StaffMessage.find( params[ :message_id ] )
  end

  private def strong_params
    params.require(:customer_message).permit(:subject, :body)
  end

end
