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

  def delimiter_num( _number )
    return "" unless _number
    number_with_delimiter(_number)
  end

  def formated_text( text )
    ERB::Util.html_escape( text ).gsub(/\n/, "<br>").html_safe
  end

end
