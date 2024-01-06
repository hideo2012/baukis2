class Tag < ApplicationRecord
  has_many :msg_tag_links, dependent: :destroy
  has_many :messages, through: :msg_tag_links 
end
