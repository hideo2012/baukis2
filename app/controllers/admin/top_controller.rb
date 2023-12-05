class Admin::TopController < Admin::Base
  #skip_before_action :authorize
  #before_action :admin_check

  def index
    #render action: "index"
    if current_administrator
      render action: "dashboard"
    else
      render action: "index"
    end
  end
end
