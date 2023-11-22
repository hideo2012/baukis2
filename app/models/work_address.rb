class WorkAddress < Address
  before_validation do
    self.company_name = normalize_as_name( company_name )
    self.division_name = normalize_as_name( division_name )
  end

  validates :company_name, presence: true

  def strong_params( params )
    params.require( :work_address ).permit(
      :postal_code,
      :prefecture, :city,
      :address1, :address2,
      :company_name, :division_name,
    )
  end
end
