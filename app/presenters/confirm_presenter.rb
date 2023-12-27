class ConfirmPresenter
  include HtmlBuilder

  attr_reader :form_builder, :view_context

  delegate( 
      :label, 
      :text_field, 
      :hidden_field,
      :object, 
      to: :form_builder )

  def initialize( form_builder, view_context )
    @form_builder = form_builder
    @view_context = view_context
  end

  def decorated_label( name, label_text )
    label( name, label_text )
  end

  def text_field_block( name, label_text, options = {} )
    markup( :div ) do |m|
      m << decorated_label( name, label_text )
      m.div( object.send(name) )
      unless options[:desabled]
        m << hidden_field( name )
      end
    end
  end

  def full_name_block( name1, name2, label_text )
    markup(:div ) do |m|
      m << decorated_label( name1, label_text )
      m.div( object.send(name1) + " " + object.send(name2)  )
      m << hidden_field( name1 )
      m << hidden_field( name2 )
    end
  end

  def gender_field_block
    markup( :div ) do |m|
      m << decorated_label( :gender, "性別" )
      m.div( object.gender_desc )
      m << hidden_field( :gender )
    end
  end

end
