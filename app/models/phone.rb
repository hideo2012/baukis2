class Phone < ApplicationRecord
  include StringNormalizer

  belongs_to :customer, optional: true
  belongs_to :address,  optional: true

  before_validation do
    self.number = normalize_as_phone_number( number )
    self.number_for_index = number.gsub( /\D/, "" ) if number
  end

  validates :number, presence: true,
    format: { with: /\A\+?\d+(-\d+)*\z/, allow_blank: true }

  before_create do
    self.customer = address.customer if address
  end

  def assign_nested_attributes( _params )
    if _params[:number].present?
      assign_attributes( _params )
    else
      mark_for_destruction
    end
  end

end
