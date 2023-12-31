require "nkf"

module StringNormalizer extend ActiveSupport::Concern

  def normalize_as_email( text )
    NKF.nkf( "-W -w -Z1", text ).strip if text
  end

  def normalize_as_name(text)
    NKF.nkf( "-W -w -Z1", text ).strip if text
    #or NKF.nkf( "-WwZ1", text ).strip if text
  end

  def normalize_as_furigana( text )
    NKF.nkf( "-W -w -Z1 --katakana", text ).strip if text
  end

  def normalize_as_postal_code( text )
    NKF.nkf( "-W -w -Z1", text ).strip.gsub(/-/, "") if text
  end

  def normalize_as_phone_number( text )
    NKF.nkf( "-W -w -Z1", text ).strip if text
  end

  def normalize_as_phone_number_no_hyphen( text )
    NKF.nkf( "-W -w -Z1", text ).strip.gsub(/\D/, "") if text
  end

end


