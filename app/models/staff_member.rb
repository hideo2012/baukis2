class StaffMember < ApplicationRecord
  include EmailHolder
  include PersonalNameHolder
#  include PasswordHolder

  # :events は、メソッド名
  has_many :events, class_name: "StaffEvent", dependent: :destroy

  validates :start_date, presence: true, date: {
    after_or_equal_to: Date.new( 2000, 1, 1 ),
    before: ->( obj ) { 1.year.from_now.to_date },
    allow_blank: true
  }

  validates :end_date,  date: {
    after: :start_date,
    before: ->( obj ) { 1.year.from_now.to_date },
    allow_blank: true
  }
#before:  1.year.from_now.to_date  #NG because ... now = server start up time 

  def password=( _raw_password )
    if _raw_password.kind_of?( String )
      self.hashed_password = 
        BCrypt::Password.create( _raw_password )
    elsif _raw_password.nil?
      self.hashed_password = nil
    end
  end

  def authenticate( _raw_password )
    hashed_password &&
      start_date <= Date.today &&
      ( end_date.nil? || end_date > Date.today ) &&
      BCrypt::Password.new( hashed_password ) == _raw_password
  end

  def active?
    !suspended? && start_date <= Date.today &&
      ( end_date.nil? || end_date > Date.today )
  end

  def full_name
    family_name + given_name
  end

  ####  for change password #### Start
=begin
  attr_accessor :current_password, :new_password,
    :new_password_confirmation

  validates :new_password, presence: true,  
            confirmation: true, on: :change_pass
  validate  on: :change_pass  do
    unless authenticate( current_password )
      errors.add( :current_password, :wrong )
    end
  end

  before_update :update_password_if_new 

  private def update_password_if_new
    if new_password
      password = new_password
    end
    true
  end
  ####  for change password #### END


  def assign_for_changepass( _params )
    filterd_params = _params.require(:staff_member)
      .permit(:current_password, 
              :new_password, 
              :new_password_confirmation )
    assign_attributes(filterd_params)
  end

  def assign_for_selfedit( _params )
    filterd_params = _params.require(:staff_member)
      .permit(
        :email, :family_name, :given_name,
        :family_name_kana, :given_name_kana
      )
    assign_attributes( filterd_params )
  end
=end

end
