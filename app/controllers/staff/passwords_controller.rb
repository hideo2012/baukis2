class Staff::PasswordsController < Staff::Base

  def show
    redirect_to :edit_staff_password
  end

  def edit
    @form = 
      Staff::ChangePasswordForm.new( staff: current_staff_member )
  end

  def update
    @form = Staff::ChangePasswordForm.new( strong_params )
    @form.staff = current_staff_member
    if @form.save
      flash.notice = " パスワードを変更しました。 "
      redirect_to :staff_account
    else
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "edit"
    end
  end

  private def strong_params
    params.require(:form).permit(
      :current_password, 
      :new_password, 
      :new_password_confirmation )
  end

=begin
  def edit
    @staff_member = current_staff_member
  end

  def update
    @staff_member = current_staff_member
    @staff_member.assign_for_changepass( params )
    if @staff_member.save( context: :change_pass )
      flash.notice = " パスワードを変更しました。 "
      redirect_to :staff_account
    else
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "edit"
    end
  end

  private def strong_params
    params.require( :staff_change_password_form ).permit(
      :current_password, :new_password, :new_password_confirmation )
  end

=end

end
