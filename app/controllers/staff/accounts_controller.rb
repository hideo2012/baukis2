class Staff::AccountsController < Staff::Base
  before_action :staff_member_check

  def show
    @staff_member = current_staff_member
  end

  def edit
    @staff_member = current_staff_member
  end

  def update
    @staff_member = current_staff_member
    @staff_member.assign_attributes( strong_params )
    if @staff_member.save
      flash.notice = "アカウント情報を更新しました。"
      redirect_to :staff_account
    else
      render action: "edit"
    end
  end

  private def strong_params
    params.require(:form).permit(
      :email, 
      :family_name, :given_name,
      :family_name_kana, :given_name_kana
    )
  end

end

  
