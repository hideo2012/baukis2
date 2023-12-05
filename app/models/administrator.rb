class Administrator < ApplicationRecord
  include EmailHolder

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

  def active?
    !suspended?
  end
end
