class Customer::Base < ApplicationController
  #before_action :authorize
  #before_action :check_account
  #before_action :check_timeout
  
  private def current_customer
    customer_id = ( cookies.signed[:customer_id] || session[:customer_id] )
    if customer_id
        @current_customer ||= Customer.find_by( id: customer_id )
    end
  end

  helper_method :current_customer

  def customer_check
    authorize
    #check_account
    #check_timeout
  end

  private def authorize
    unless current_customer
      flash.alert = "ログインしてください。"
      redirect_to :customer_login
    end
  end

  # todo
  private def check_account
    if current_customer && !current_customer.active?
      session.delete(:customer_id)
      flash.alert = "アカウントが無効になりました。"
      redirect_to :customer_root
    end
  end

  TIMEOUT = 60.minutes

  # todo
  private def check_timeout
    if current_customer && session[:last_access_time]
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        session.delete(:customer_id)
        flash.alert = "セッションがタイムアウトしました。"
        redirect_to :customer_login
      end
    end
  end
end
