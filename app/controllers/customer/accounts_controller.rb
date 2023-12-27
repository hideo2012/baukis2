class Customer::AccountsController < Customer::Base
  before_action :customer_check

  def show
    @customer = current_customer
    @customer.build_empty_address_and_phones
  end

  def edit
    @customer = current_customer
    @customer.build_empty_address_and_phones
  end

  def confirm
    @customer = current_customer
    @customer.assign_nested_attributes( strong_params )
    if @customer.invalid?
      flash.now.alert = "入力に誤りがあります。"
      render action: "edit"
    end
  end

  def update
    @customer = current_customer
    @customer.assign_nested_attributes( strong_params )
    if params[:correct]
      render action: "edit"
      return
    end
    if @customer.save
      flash.notice = " アカウント情報を更新しました。"
      redirect_to :customer_account
    else
      flash.now.alert = "入力に誤りがあります。"
      render action: "edit"
    end
  end

  private def strong_params
    params.require(:customer).permit(
      #:email, :password,
      :family_name, :given_name, 
      :family_name_kana, :given_name_kana, 
      :birthday, :gender,
      :inputs_home_address, 
      :inputs_work_address,
      phones: [ :number, :primary ],
      home: [
        :postal_code,
        :prefecture, :city,
        :address1, :address2,
        phones: [ :number, :primary ],
      ],
      work: [
        :postal_code,
        :prefecture, :city,
        :address1, :address2,
        :company_name, :division_name,
        phones: [ :number, :primary ],
      ] 
    )
  end

end
