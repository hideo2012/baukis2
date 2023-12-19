class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.integer :registrant_id, null: false # 登録職員（外部キー）
      t.string :title, null: false     # タイトル
      t.text :description, null: false # 説明
      t.datetime :application_start_time, null: false # 申込み開始日時
      t.datetime :application_end_time, null: false   # 申込み終了日時
      t.integer :min_number_of_participants # 最小参加者数
      t.integer :max_number_of_participants # 最大参加者数

      t.timestamps
    end
  end
end
