class Staff::Base < ApplicationController
  before_action :check_source_ip_address
  
  helper_method :current_staff_member
  private def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
        StaffMember.find_by(id: session[:staff_member_id])
    end
  end

  # ログイン済前提のアクション実行時呼び出す
  def staff_member_check
    return unless authorize 
    return unless check_account 
    return unless check_timeout
  end

  private def check_source_ip_address
    if AllowedSource.include?("staff", request.ip)
      return true 
    else
      session_delete
      return false if ajax? 
      raise IpAddressRejected
      return false #TODO 無効？
    end
  end

  private def authorize
    if current_staff_member
      return true
    else
      return false if ajax?
      flash.alert = "職員としてログインしてください。"
      redirect_to :staff_login
      return false
    end
  end

  # ログイン中職員が有効か確認（戻り値：処理中断判定 ） 
  private def check_account
    if current_staff_member && 
        current_staff_member.active? 
      return true
    else
      session_delete
      return false if ajax?
      flash.alert = " アカウントが無効になりました。"
      redirect_to :staff_root
      return false
    end
  end

  TIMEOUT = 60.minutes

  private def check_timeout
    unless current_staff_member && session[:last_access_time]
      return true # ログイン状態はチェック不要（実際はあり得ない？）
    end
    if session[:last_access_time] >= TIMEOUT.ago
      session[:last_access_time] = Time.current
      return true
    else
      session_delete
      return false if ajax?
      flash.alert = "セッションがタイムアウトしました。"
      redirect_to :staff_login
      return false
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

  private def session_delete
    session.delete(:staff_member_id)
  end
end
