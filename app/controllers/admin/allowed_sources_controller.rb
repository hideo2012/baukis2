class Admin::AllowedSourcesController < Admin::Base
  before_action :admin_check

  def index
    @allowed_sources = AllowedSource.where( namespace: "staff" )
      .order( :octet1,:octet2, :octet3, :octet4 )  
    @new_allowed_source = AllowedSource.new
  end

  def create
    @new_allowed_source = AllowedSource.new( strong_params )
    @new_allowed_source.namespace = "staff"

    if @new_allowed_source.save
      flash.notice = "許可IPアドレスを追加しました。"
      redirect_to action: "index"
    else
      @allowed_sources = 
        AllowedSource.where( namespace: "staff" )
        .order( :octet1,:octet2, :octet3, :octet4 )  
      flash.now.alert = "許可IPアドレスの値が正しくありません。"
      render action: "index"
    end
  end

  def delete
    ids = delete_list
    if ids.present?
      AllowedSource.where(namespace: "staff", id: ids).delete_all
      flash.notice = " 許可IPアドレスを削除しました。 "
    end
    redirect_to action: "index"
  end

  private def strong_params
    params.require(:allowed_source).permit(
      :octet1, :octet2, :octet3, :last_octet) 
  end

  private def delete_list
    ids = []
    if params[:form] && params[:form][:allowed_sources]
      params[:form][:allowed_sources].values.each do |h|
        ids << h[:id]  if h[:_destroy] == "1"
      end
    end
    ids
  end


end
