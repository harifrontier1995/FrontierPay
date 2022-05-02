require 'uri'
require 'net/http'

class TwoFactor
  API_KEY = Rails.application.credentials.API_KEY
  def self.send_otp_code phone_no
  	otp = TwoFactor.generate_otp
    begin
      response = TWILIO.api.account.messages.create(:from => "+1#{8453799597}", :to => "+91#{phone_no}",:body => "#{otp}")
      otp_sent = response.status == "queued" 
    rescue
      url = URI("http://2factor.in/API/V1/#{API_KEY}/SMS/#{phone_no}/#{otp}")
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      response = http.request(request)
      otp_sent = response["Status"] == "Success"
    end  
    [otp_sent, otp]
  end

  def self.generate_otp
    SecureRandom.random_number(100000)
  end
end