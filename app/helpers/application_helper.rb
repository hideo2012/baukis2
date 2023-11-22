module ApplicationHelper
  include HtmlBuilder

  def document_title
    if @title.present?
      "#{@title} - Baukis2"
    else
      "Baukis2"
    end
  end

  # On:  BALLOT BOX WITH CHECK (U+2611)
  # Off: BALLOT BOX (U+2610)
  def flag_mark( flag )
    flag ? raw( "&#x2611;" ) : raw( "&#x2610;" )
  end

  def datetime_view( datetime )
    datetime.try( :strftime, "%Y/%m/%d %H:%M:%S" )
  end

  def date_view( date )
    date.try( :strftime, "%Y/%m/%d" )
  end



end
