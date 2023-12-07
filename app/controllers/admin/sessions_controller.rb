class Admin::SessionsController < Admin::Base
  #skip_before_action :authorize
  #before_action :admin_check
  
  def new
    if current_administrator
      redirect_to :admin_root
    else
      @form = Admin::LoginForm
      render action: "new"
    end
  end

  def create
    #@form = Admin::LoginForm.new( params[:admin_login_form] )
    @form = Admin::LoginForm.new( strong_params )
    if @form.email.present?
      administrator =
        Administrator.find_by( "LOWER(email) = ?", @form.email.downcase )
    end
    if administrator && administrator.authenticate(@form.password)
      if administrator.suspended?
        flash.now.alert = "アカウントが停止されています。"
        render action: "new"
      else
        session[:administrator_id] = administrator.id
        session[:last_access_time] = Time.current
        flash.notice = "ログインしました。"
        redirect_to :admin_root
      end
    else
      flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
      render action: "new"
    end
  end

  private def strong_params
    params.require( :form ).permit( :email, :password )
  end

  def destroy
    session.delete( :administrator_id )
    flash.notice = "ログアウトしました。"
    redirect_to :admin_root
  end
end
