class Staff::Base < ApplicationController
  before_action :check_source_ip_address
  #before_action :authorize
  #before_action :check_account
  #before_action :check_timeout
  
  private def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
        StaffMember.find_by(id: session[:staff_member_id])
    end
  end

  helper_method :current_staff_member


  def staff_member_check
    #check_source_ip_address
    authorize
    check_account
    check_timeout
  end

  private def check_source_ip_address
    #raise IpAddressRejected unless AllowedSource.include?("staff", request.ip)
    return  if AllowedSource.include?("staff", request.ip)
    raise IpAddressRejected unless ajax?
    render plain: "Forbidden", status: 403
  end

  private def authorize
=begin
    unless current_staff_member
      flash.alert = "職員としてログインしてください。"
      redirect_to :staff_login
    end
=end
    return if current_staff_member
    if ajax? 
      render plain: "Forbidden", status: 403
    else
      flash.alert = "職員としてログインしてください。"
      redirect_to :staff_login
    end
  end

  private def check_account
=begin
    if current_staff_member && !current_staff_member.active?
      session.delete(:staff_member_id)
      flash.alert = "アカウントが無効になりました。"
      redirect_to :staff_root
    end
=end
    return if current_staff_member && current_staff_member.active?
    if ajax? 
      render plain: "Forbidden", status: 403
    else
      session.delete(:staff_member_id)
      flash.alert = "アカウントが無効になりました。"
      redirect_to :staff_root
    end
  end

  TIMEOUT = 60.minutes

  private def check_timeout
    #TODO 
    if current_staff_member && session[:last_access_time]
      if session[:last_access_time] >= TIMEOUT.ago
        session[:last_access_time] = Time.current
      else
        session.delete(:staff_member_id)
        flash.alert = "セッションがタイムアウトしました。"
        redirect_to :staff_login
      end
    end
  end


  private def ajax?
    #p ">>> cntrl name :#{controller_name} <<<"
    controller_name == "ajax" ? true : false
  end
end


