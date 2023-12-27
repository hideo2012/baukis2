class FormPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context

  delegate( 
      :label, 
      :hidden_field, 
      :text_field, 
      :date_field, 
      :password_field, 
      :check_box, 
      :radio_button, 
      :text_area, 
      :object, 
      to: :form_builder )

  def initialize( form_builder, view_context )
    @form_builder = form_builder
    @view_context = view_context
  end

  def notes
    markup( :div, class: "notes" ) do |m|
      m.span "*", class: "mark"
      m.text " 印の付いた項目は入力必須です。 "
    end
  end

  def text_field_block( name, label_text, options = {} )
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( name, label_text, options )
      m << text_field( name, options )
      if options[:maxlength]
        m.span "#{options[:maxlength]} 文字以内", class: "instruction"
      end
      m << error_messages_for( name )
    end
  end

  def number_field_block( name, label_text, options = {} )
    markup( :div ) do |m|
      m << decorated_label( name, label_text, options )
      m << form_builder.number_field( name, options )
      if options[:max]
        max = view_context.number_with_delimiter( options[:max].to_i )
        m.span "( 最大値：#{max} )", class: "instruction"
      end
      m << error_messages_for( name )
    end
  end

  def password_field_block( name, label_text, options = {} )
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( name, label_text, options )
      m << password_field( name, options )
      m << error_messages_for( name )
    end
  end

  def date_field_block( name, label_text, options = {} )
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( name, label_text, options )
      m << date_field( name, options )
      m << error_messages_for( name )
    end
  end

  def datetime_field_block( name, label_text, options = {} )
    instruction = options.delete(:instruction)
    if object.errors.include?("#{name}_time".to_sym)
      html_class = "input-block with-errors"
    else
      html_class = "input-block"
    end
    markup( :div, class: html_class ) do |m|
      m << decorated_label( "#{name}_date", label_text, options )
      m << date_field( "#{name}_date", options )
      m << form_builder.select( "#{name}_hour", hour_options )
      m << ":"
      m << form_builder.select( "#{name}_minute", minute_options )
      m.span "(#{instruction})", class: "instruction" if instruction
      m << error_messages_for( "#{name}_time".to_sym )
      m << error_messages_for( "#{name}_date".to_sym  )
    end
  end

  private def hour_options
    (0..23).map { |h| [ "%02d" % h, h ] }
  end

  private def minute_options
    (0..11).map { |n| n * 5 }  
      .map { |m| [ "%02d" % m, m ] } 
  end

  def description
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( :description, "詳細", required: true )
      m << text_area( :description, rows: 6, style: "width: 454px" )
      m.span "(800文字以内)", class: "instruction", style: "float: right" 
    end
  end


  def drop_down_list_block( name, label_text, choices, options = {} )
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( name, label_text, options )
      m << form_builder.select( name, choices,
                               { include_blank: true }, options )
      m << error_messages_for( name )
    end
  end

  def check_box_block( name, label_text )
    markup(:div, class: "check-boxes") do |m|
      m << check_box(name)
      m << label(name, label_text)
    end
  end

  def error_messages_for( name )
    markup do |m|
      object.errors.full_messages_for( name ).each do |message|
        m.div( class: "error-message" ) do |m|
          m.text message
        end
      end
    end
  end

#  def password_field_block(name, label_text, options = {} )
#    if object.new_record?
#      super(name, label_text, options)
#    end
#  end

  def full_name_block( name1, name2, label_text, options = {} )
    markup(:div, class: "input-block" ) do |m|
      m << decorated_label( name1, label_text, options )
      m << text_field( name1, options )
      m << text_field( name2, options )
      m << error_messages_for( name1 )
      m << error_messages_for( name2 )
    end
  end

  def gender_field_block
    markup( :div, class: "radio-buttons" ) do |m|
      m << decorated_label( :gender, "性別" )
      m << radio_button( :gender, "male" )
      m << label( :gender_male, "男性" )
      m << radio_button( :gender, "female" )
      m << label( :gender_female, "女性" )
    end
  end

  def postal_code_block( name, label_text, options )
    markup( :div, class: "input-block" ) do |m|
      m << decorated_label( name, label_text, options )
      m << text_field( name, options )
      m.span "(7桁の半角数字で入力してください。)", class: "notes"
      m << error_messages_for( name )
    end
  end

  def suspended_check_box
    markup(:div, class: "check-boxes") do |m|
      m << check_box(:suspended)
      m << label( :suspended, " アカウント停止 " )
    end
  end

  def text_field_hidden( name, label_text, options = {} )
    markup( :div ) do |m|
      m << decorated_label( name, label_text )
      m.div( object.send(name) )
      unless options[:desabled]
        m << hidden_field( name )
      end
    end
  end

  def full_name_hidden( name1, name2, label_text )
    markup(:div ) do |m|
      m << decorated_label( name1, label_text )
      m.div( object.send(name1) + " " + object.send(name2)  )
      m << hidden_field( name1 )
      m << hidden_field( name2 )
    end
  end

  def gender_field_hidden
    markup( :div ) do |m|
      m << decorated_label( :gender, "性別" )
      m.div( object.gender_desc )
      m << hidden_field( :gender )
    end
  end

  def decorated_label( name, label_text, options = {} )
    label( name, label_text, class: options[:required] ? "required" : nil )
  end
end
