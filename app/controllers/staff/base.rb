class Staff::Base < ApplicationController
  before_action :check_source_ip_address
  #before_action :staff_member_check
  
  helper_method :current_staff_member

  private def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
        StaffMember.find_by(id: session[:staff_member_id])
    end
  end

  def staff_member_check
    return unless authorize 
    return unless check_account 
    return unless check_timeout
  end

  private def check_source_ip_address
    return true if AllowedSource.include?("staff", request.ip)
    session_delete
    if ajax? 
      render plain: "Forbidden", status: 403
    else
      raise IpAddressRejected
    end
    return false
  end

  private def authorize
    return true if current_staff_member
    if ajax? 
      render plain: "Forbidden", status: 403
    else
      flash.alert = "職員としてログインしてください。"
      redirect_to :staff_login
    end
    return false
  end

  private def check_account
    return true if current_staff_member && current_staff_member.active?
    session_delete
    if ajax? 
      render plain: "Forbidden", status: 403
    else
      flash.alert = " アカウントが無効になりました。"
      redirect_to :staff_root
    end
    return false
  end

  TIMEOUT = 60.minutes

  private def check_timeout
    return true unless ( current_staff_member && session[:last_access_time] )
    if session[:last_access_time] >= TIMEOUT.ago
      session[:last_access_time] = Time.current
      return true
    end
    session_delete
    if ajax?
      render plain: "Forbidden", status: 403
    else
      flash.alert = "セッションがタイムアウトしました。"
      redirect_to :staff_login
    end
    return false
  end

  private def ajax?
    controller_name == "ajax" ? true : false
  end

  private def session_delete
    session.delete(:staff_member_id)
  end
end
