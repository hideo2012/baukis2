class MessagePresenter  <  ModelPresenter
  #delegate :subject, :body, to: :object

  def tree
    expand( object.root_message )
  end

  private def expand( node )
    markup(:ul) do |m|
      m.li do
        if node.id == object.id
          m.strong( node.subject )
        else
          m << link_to( node.subject, view_context.staff_message_path( node ) )
        end

        node.children.each do |c|
          m << expand( c )
        end

      end # end of LI
    end # end of UL
  end
end

