class Admin::StaffEventsController < Admin::Base
  before_action :admin_check

  def index
    if params[:staff_member_id]
      @staff_member = StaffMember.find(params[:staff_member_id]) 
      #logger.debug "=== #{@staff_member} ==="
      @events = @staff_member.events
    else
      @events = StaffEvent
    end
    @events = @events.order( occurred_at: :desc )
      .includes( :member )
      .page( params[:page] )
  end
end
