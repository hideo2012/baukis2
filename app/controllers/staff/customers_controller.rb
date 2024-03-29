class Staff::CustomersController < Staff::Base

  def index
    @search_form = Staff::CustomerSearchForm.new( search_strong_params )
    @customers = @search_form.search.page( params[:page] )
  end

  def show
    @customer = Customer.find( params[:id] )
    @customer.build_empty_address_and_phones
  end

  def new
    @customer = Customer.new
    @customer.build_empty_address_and_phones
  end

  def edit
    @customer = Customer.find( params[:id] )
    @customer.build_empty_address_and_phones
  end

  def create
    @customer = Customer.new
    @customer.assign_nested_attributes( strong_params )
    if @customer.save
      flash.notice = "顧客情報を追加しました。"
      redirect_to action: "index"
    else
      flash.now.alert = "入力に誤りがあります。"
      render action: "new"
    end
  end

  def update
    @customer = Customer.find( params[:id] )
    @customer.assign_nested_attributes( strong_params )
    if @customer.save
      flash.notice = "顧客情報を更新しました。"
      redirect_to action: "index"
    else
      flash.now.alert = "入力に誤りがあります。"
      render action: "edit"
    end
  end

  def destroy
    customer = Customer.find( params[:id] )
    customer.destroy!
    flash.notice = "顧客アカウントを削除しました。"
    redirect_to :staff_customers
  end

  private def strong_params
    params.require(:customer).permit(
      :email, :password,
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

  private def search_strong_params
    params[:search]&.permit([
      :family_name_kana, :given_name_kana,
      :birth_year, :birth_month, :birth_mday,
      :address_type, :prefecture, :city, :phone_number,
      :gender, :postal_code
    ])
  end

end
