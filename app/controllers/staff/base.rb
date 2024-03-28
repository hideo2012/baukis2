class Staff::Base < ApplicationController
  before_action :check_source_ip_address
  before_action :authorize
  helper_method :current_staff_member

  private def authorize
    unless current_staff_member
      return false if ajax?
      flash.alert = "職員としてログインしてください。"
      redirect_to :staff_login
      return
    end
    unless current_staff_member.active? 
      session.delete(:staff_member_id)
      return false if ajax?
      flash.alert = " アカウントが無効になりました。"
      redirect_to :staff_root
      return
    end
    if timeout?
      session.delete(:staff_member_id)
      return false if ajax?
      flash.alert = "セッションがタイムアウトしました。"
      redirect_to :staff_login
      return
    end
  end

  private def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
        StaffMember.find_by(id: session[:staff_member_id])
    end
  end

  TIMEOUT = 60.minutes

  private def timeout?
    if session[:last_access_time] &&
        session[:last_access_time] >= TIMEOUT.ago
      session[:last_access_time] = Time.current
      return false
    else
      return true
    end
  end

  private def ajax?
    if controller_name == "ajax" 
      render plain: "Forbidden", status: 403
      return true
    else
      return false
    end
  end

  private def check_source_ip_address
    if AllowedSource.include?("staff", request.ip)
      return true 
    else
      session.delete(:staff_member_id)
      return false if ajax? 
      raise IpAddressRejected
    end
  end
end
