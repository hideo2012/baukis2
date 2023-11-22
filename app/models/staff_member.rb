class StaffMember < ApplicationRecord
  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

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
    #before:  1.year.from_now.to_date  #NG because ... now = server start up time 
    allow_blank: true
  }

  def active?
    !suspended? && start_date <= Date.today &&
      ( end_date.nil? || end_date > Date.today )
  end

  def full_name
    family_name + given_name
  end

end
