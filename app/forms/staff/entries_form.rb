class Staff::EntriesForm
  include ActiveModel::Model

  attr_accessor :program, 
    :approved, 
    :not_approved, 
    :canceled, 
    :not_canceled

  def save
    ActiveRecord::Base.transaction do
      update_flag( approved,      approved: true   )
      update_flag( not_approved,  approved: false  )
      update_flag( canceled,      canceled: true   )
      update_flag( not_canceled,  canceled: false  )
    end
  end

  private def update_flag( _ids, _flag )
    return true unless _ids.present?
    ids = _ids.split(":").map(&:to_i)
    program.entries.where( id: ids ).update_all( _flag )
  end

end
