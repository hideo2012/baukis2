class Customer < ApplicationRecord
  attribute :gender, default: 'female'
  attr_accessor :inputs_home_address, :inputs_work_address

  include EmailHolder
  include PersonalNameHolder
  #include PasswordHolder

  has_many :addresses, dependent: :destroy
  has_one :home_address, autosave: true
  has_one :work_address, autosave: true
  has_many :phones,      dependent: :destroy
  has_many :personal_phones, 
    ->{ where( address_id: nil ).order( :id ) },
    class_name: "Phone", autosave: true
  has_many :entries, dependent: :destroy
  has_many :programs, through: :entries # , source: program (省略可能)



  validates :gender, inclusion: { 
    in: %w(male female), allow_blank: true }

  validates :birthday, date: {
    after: Date.new(1900,1,1),
    before: ->(obj) { Date.today },
    allow_blank: true
  }

  before_save do
    if birthday
      self.birth_year = birthday.year
      self.birth_month = birthday.month
      self.birth_mday = birthday.mday
    end
  end

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
        BCrypt::Password.new( hashed_password ) == _raw_password
  end


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

  def build_empty_address_and_phones
    self.inputs_home_address = home_address.present? ? "1" : "0"
    self.inputs_work_address = work_address.present? ? "1" : "0"
    build_home_address unless home_address.present?
    build_work_address unless work_address.present?
    build_empty_phones( personal_phones )
    build_empty_phones( home_address.phones )
    build_empty_phones( work_address.phones )
  end
   
  private def build_empty_phones( _phones )
    ( 2 - _phones.size ).times do
      _phones.build
    end
  end

  def assign_nested_attributes( _params )
    build_empty_address_and_phones
    assign_attributes( _params.except(:phones, :home, :work ) ) 
    personal_phones.size.times do |i|
      personal_phones[i].assign_nested_attributes( _params[:phones][i.to_s] )
    end
    self.home_address.inputs = ( _params[:inputs_home_address] == "1" )
    home_address.assign_nested_attributes( _params[:home] )
    self.work_address.inputs = ( _params[:inputs_work_address] == "1" )
    work_address.assign_nested_attributes( _params[:work] )
  end
end
