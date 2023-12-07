class Customer::TopController < Customer::Base

  def index
    #raise ActiveRecord::RecordNotFound
    render action: "index"
  end
end
