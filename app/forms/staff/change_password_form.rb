class Staff::ChangePasswordForm
  include ActiveModel::Model

  attr_accessor :staff, 
    :current_password, 
    :new_password,
    :new_password_confirmation

  validates :new_password, presence: true,  confirmation: true

  validate do
    unless staff.authenticate( current_password )
      errors.add( :current_password, :wrong )
    end
  end

  def save
    if valid?
      staff.password = new_password
      staff.save!
    end
  end
end
