class Customer::TopController < Customer::Base

  def index
    #raise ActiveRecord::RecordNotFound
    if current_customer
      render action: "dashboard"
    else
      render action: "index"
    end
  end
end
