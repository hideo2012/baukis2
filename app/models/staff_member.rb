class StaffMember < ApplicationRecord
  include EmailHolder
  include PersonalNameHolder
#  include PasswordHolder

  has_many :events, class_name: "StaffEvent", dependent: :destroy
  has_many :programs, foreign_key: "registrant_id", dependent: :restrict_with_exception

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

  def deletable?
    programs.empty?
  end

  def full_name
    family_name + "" + given_name
  end

end
