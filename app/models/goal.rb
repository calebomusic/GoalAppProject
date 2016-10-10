class Goal < ActiveRecord::Base
  validates :description, :status, :private, :user_id, presence: true

  belongs_to :user

  
end
