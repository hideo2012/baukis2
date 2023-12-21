class Staff::ProgramsController < Staff::Base
  before_action :staff_member_check

  def index
    @programs = Program.listing.page( params[:page] )
  end

  def show
    @program = Program.listing.find( params[:id] )
  end

  def new
    @program = Program.new
  end

  def edit
    @program = Program.find( params[:id] )
    #@program.init_virtual_attributes
  end

  def create
    @program = Program.new
    @program.assign_attributes( strong_params )
    @program.registrant = current_staff_member
    if @program.save
      flash.notice = " プログラムを登録しました。 "
      redirect_to action: "index"
    else
      flash.now.alert = " 入力に誤りがあります。 "
      render action: "new"
    end
  end

  def update
    @program = Program.find( params[:id] )
    @program.assign_attributes( strong_params )
    if @program.save
      flash.notice = " プログラムを更新しました。 "
      redirect_to action: "index"
    else
      flash.alert = " 入力に誤りがあります。 "
      render action: "edit"
    end
  end

  def destroy
    @program = Program.find( params[:id] )
    if @program.deletable?
      @program.destroy!
      flash.notice = " プログラムを削除しました。 "
      #redirect_to action: "index"  TODO あれ？これでもいいじゃね？
      redirect_to :staff_programs
    else
      flash.alert = " このプログラムは削除できません。 "
      redirect_to action: "index"
    end
  end

  private def strong_params
    params.require(:program).permit([
      :title,
      :description, 
      :application_start_date, 
      :application_start_hour, 
      :application_start_minute, 
      :application_end_date, 
      :application_end_hour, 
      :application_end_minute, 
      :min_number_of_participants ,
      :max_number_of_participants ,
    ])
  end

end
