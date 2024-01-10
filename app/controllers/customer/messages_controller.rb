class Customer::MessagesController < Customer::Base
  before_action :customer_check

  def index
    @messages = StaffMessage.not_deleted.where( customer: current_customer )
      #.sorted
      #.page( params[:page] )
  end

  def show
    @message = Message.find( params[:id ] )
  end
  
  def new
    @message = CustomerMessage.new
  end

  # POST
  def confirm
    @message = CustomerMessage.new(strong_params)
    @message.customer = current_customer
    if @message.invalid?
      flash.now.alert =  " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  def create
    @message = CustomerMessage.new(strong_params)
    @message.customer = current_customer
    if params[:correct]
      render action: "new"
      return
    end
    if @message.save
      flash.notice =  " 問い合わせを送信しました。 "
      redirect_to :customer_root
    else
      flash.now.alert =  " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  def destroy
    message = StaffMessage.find( params[:id ] )
    message.update_column( :deleted, true )
    flash.notice = "メッセージを削除しました。 "
    redirect_to :customer_messages
  end


  private def strong_params
    params.require(:customer_message).permit(:subject, :body)
  end
end
