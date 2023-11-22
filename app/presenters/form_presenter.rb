class FormPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context

  delegate( 
      :label, 
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

  def decorated_label( name, label_text, options = {} )
    label( name, label_text, class: options[:required] ? "required" : nil )
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



end
