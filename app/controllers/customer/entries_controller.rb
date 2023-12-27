class Customer::EntriesController < Customer::Base
  before_action :customer_check

  def create
    ActiveRecord::Base.transaction do
      # lock => select for update 他セッションはentryを追加できない？(排他的ロックと外部キー制約)
      program = Program.lock.published.find( params[:program_id] )
      raise if program.before_start?
      if program.applied?( current_customer.id )
        flash.notice = " プログラムに申し込みました。 "
      elsif program.closed_application?
        flash.alert = " プログラム申込期間が終了しました。 "
      elsif program.full_participants?
        flash.alert = " プログラムへの申込者が上限に達しました。 "
      else
        program.entries.create!( customer: current_customer )
        flash.notice = " プログラムに申し込みました。 "
      end
      redirect_to [:customer, program ]
    end
  end

  def cancel
    program = Program.published.find( params[:program_id] )
    if program.closed_application?
      flash.alert = " プログラム申込をキャンセルできません（受付期間終了） "
    else
      entry = program.find_entry( current_customer.id )
      entry.update_column( :canceled, true )
      flash.notice = " プログラム申込をキャンセルしました。 "
    end
    redirect_to [:customer, program ]
  end

end
