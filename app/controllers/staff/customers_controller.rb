class Staff::CustomersController < Staff::Base
  before_action :staff_member_check

  def index
    @customers = Customer.order( :family_name_kana, :given_name_kana )
      .page( params[:page])
  end

  def show
    @customer = Customer.find( params[:id] )
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = Customer.find( params[:id] )
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
    #p ">> cntroler params:>>#{params}<<"
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

end
