class HomeAddress < Address
  validates :postal_code, :prefecture, :city, :address1, 
    presence: true
  validates :company_name, :division_name, 
    absence: true

  def strong_params( params )
    params.require( :home_address ).permit(
      :postal_code,
      :prefecture, :city,
      :address1, :address2,
    )
  end
end

