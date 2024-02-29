class Staff::CustomerSearchForm
  include ActiveModel::Model
  include StringNormalizer

  attr_accessor :family_name_kana, :given_name_kana,
    :birth_year, :birth_month, :birth_mday,
    :address_type, :prefecture, :city, :phone_number,
    :gender, :postal_code

  def search
    normalize_values
    @rel = Customer
    condition( :customers, :family_name_kana )
    condition( :customers, :given_name_kana )
    condition( :customers, :birth_year )
    condition( :customers, :birth_month )
    condition( :customers, :birth_mday )
    condition( :customers, :gender )

    if address_type.present?
      @rel = @rel.joins( "#{address_type}_address".to_sym )
    else
      @rel = @rel.joins( :addresses )
    end

    condition( :addresses, :prefecture )
    condition( :addresses, :city )
    condition( :addresses, :postal_code )

    if phone_number.present?
      @rel = @rel.joins( :phones ).where(
        "phones.number_for_index" => phone_number)
    end

    @rel = @rel.distinct
    @rel.order( :family_name_kana, :given_name_kana )
  end

  private def condition( table_name, field_name )
    val = eval(field_name.to_s) 
    return if val.blank?
    field = "#{table_name.to_s}.#{field_name.to_s}"
    @rel = @rel.where( field => val )
  end

  private def normalize_values
    self.family_name_kana = normalize_as_furigana(family_name_kana)
    self.given_name_kana = normalize_as_furigana(given_name_kana)
    self.city = normalize_as_name(city)
    self.phone_number = normalize_as_phone_number_no_hyphen(phone_number)
    self.postal_code = normalize_as_postal_code(postal_code)
  end

end
