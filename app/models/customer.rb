class Customer < ApplicationRecord
  attribute :gender, default: 'female'

  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

  has_one :home_address, dependent: :destroy, autosave: true
  has_one :work_address, dependent: :destroy, autosave: true
  has_many :phones,      dependent: :destroy
  has_many :personal_phones, 
    ->{ where( address_id: nil ).order( :id ) },
    class_name: "Phone", autosave: true

  validates :gender, inclusion: { 
    in: %w(male female), allow_blank: true }
  validates :birthday, date: {
    after: Date.new(1900,1,1),
    before: ->(obj) { Date.today },
    allow_blank: true
  }

  def full_name
    family_name + " " + given_name
  end

  def full_name_kana
    family_name_kana + " " + given_name_kana
  end

#  def birthday
#    return "" if object.birthday.blank?
#    object.birthday.strftime( "%Y/%m/%d" )
#  end

  def gender_desc
    case gender
    when "male"
      "男性"
    when "female"
      "女性"
    else
      ""
    end
  end

  def personal_phones_array
    personal_phones.map(&:number)
  end

  def initialize_for_form
    # build empty address
    self.build_home_address unless self.home_address.present?
    self.build_work_address unless self.work_address.present?

    # build personal phone max 2
    ( 2 - self.personal_phones.size ).times do
      self.personal_phones.build
    end

    # build address phone max 2
    ( 2 - self.home_address.phones.size ).times do
      self.home_address.phones.build
    end
    ( 2 - self.work_address.phones.size ).times do
      self.work_address.phones.build
    end
  end
  
  def set_from_form( _params )
    self.assign_attributes( strong_param_customer( _params ) )
    set_phones( _params, :customer, self.personal_phones )

    if _params[:inputs_home_address] == "1"
      self.home_address.set_from_form( _params, true ) 
      set_phones( _params, :home_address, self.home_address.phones )
    else
      self.home_address.set_from_form( _params, false ) 
    end

    if _params[:inputs_work_address] == "1"
      self.work_address.set_from_form( _params, true ) 
      set_phones( _params, :work_address, self.work_address.phones )
    else
      self.work_address.set_from_form( _params, false ) 
    end

  end

  private def strong_param_customer( params )
      params.require( :customer ).except(:phones).permit(
        :email, :password,
        :family_name, :given_name, 
        :family_name_kana, :given_name_kana, 
        :birthday, :gender,
      )
  end

  private def set_phones( _params, _parent_name, _phones_obj )
    phones_form = 
      _params.require( _parent_name )
      .slice( :phones ).permit(
        phones: [ :number, :primary ]
      ).fetch(:phones)

    _phones_obj.size.times do |i|
      _phones_obj[i].set_from_form( phones_form[ i.to_s ] )
    end
  end
end
