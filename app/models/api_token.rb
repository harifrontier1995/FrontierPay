class ApiToken < ApplicationRecord
	 # Model associations
  belongs_to :user

  # Validations
  validates_presence_of :user_id, :token, :ttl, :is_active
  validates_uniqueness_of :token

  def save_token token
    self.token = token
    self.ttl = Time.now+API_TOKEN_EXPIRY_TIME.minutes.to_i
    self.is_active = true
  	save!
  end

  def logout
  	self.update_column(:is_active, false)
  end

  def is_valid? http_auth_header
     is_active && 
     token == http_auth_header
  end
end
