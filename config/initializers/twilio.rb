
require 'twilio-ruby'

TWILIO = Twilio::REST::Client.new(Rails.application.credentials.ACCOUNT_SID, Rails.application.credentials.AUTH_TOKEN)