class Customer::SessionsController < Customer::Base
  
  def new
    if current_customer
      redirect_to :customer_root
    else
      @form = Customer::LoginForm
      render action: "new"
    end
  end

  def create
    @form = Customer::LoginForm.new( strong_params )
    if @form.email.present?
      customer =
        Customer.find_by( "LOWER(email) = ?", @form.email.downcase )
    end
    if customer && customer.authenticate(@form.password)
      #session[:last_access_time] = Time.current
      if @form.remember_me?
        cookies.permanent.signed[:customer_id] = customer.id
      else
        cookies.delete(:customer_id)
        session[:customer_id] = customer.id
      end

      flash.notice = "ログインしました。"
      redirect_to :customer_root
    else
      flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
      render action: "new"
    end
  end

  private def strong_params
    params.require( :form ).permit( :email, :password, :remember_me )
  end

  def destroy
    cookies.delete( :customer_id )
    session.delete( :customer_id )
    flash.notice = "ログアウトしました。"
    redirect_to :customer_root
  end
end
