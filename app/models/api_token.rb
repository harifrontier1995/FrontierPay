class ApiToken < ApplicationRecord
	 # Model associations
  belongs_to :user

  # Validations
  validates_presence_of :user_id, :token, :expiry_time, :is_active
  validates_uniqueness_of :token

  def save_token token
    self.token = token
    self.expiry_time = Time.now+30.minutes
    self.is_active = true
  	save!
  end

  def logout
  	self.update_column(:is_active, false)
  end

  def is_valid? http_auth_header
    expiry_time > Time.now.to_i && 
    is_active && 
    token == http_auth_header
  end
end
