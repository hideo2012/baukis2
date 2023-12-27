class Customer::ProgramsController < Customer::Base
  before_action :customer_check

  def index
    @programs = Program.published.page( params[:page] )
  end

  def show
    @program = Program.find( params[:id] )
    @entry = @program.find_entry( current_customer.id )
    #@entry = @program.entries.find_by( customer_id: current_customer.id )
  end
  
end
