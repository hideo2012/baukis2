class StaffEvent < ApplicationRecord
  # typeカラムの本来の特別意味を無効に
  self.inheritance_column = nil

  # :member is method name.
  belongs_to :member, class_name: "StaffMember", foreign_key: "staff_member_id"
  alias_attribute :occurred_at, :created_at

  DESCRIPTIONS = {
    logged_in: "ログイン",
    logged_out: "ログアウト",
    rejected: "ログイン拒否"
  }

  def description
    DESCRIPTIONS[type.to_sym] 
  end
end
