class Staff::EntriesController < Staff::Base

  def update_all
    #p = Program.find( params[:program_id] )
    #entries_form = Staff::EntriesForm.new( program: p )
    entries_form = Staff::EntriesForm.new
    entries_form.program = Program.find( params[:program_id] )
    entries_form.assign_attributes( strong_params )
    entries_form.save
    flash.notice = " プログラム申込みフラグを更新しました。 "
    redirect_to :staff_programs
  end

  private def strong_params
    params.require("form").permit([
      :approved, :not_approved, 
      :canceled, :not_canceled
    ])
  end
end
