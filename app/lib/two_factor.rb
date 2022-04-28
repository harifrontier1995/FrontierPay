require 'uri'
require 'net/http'

class TwoFactor
  API_KEY = Rails.application.credentials.API_KEY
  def self.send_otp_code phone_no
  	otp = TwoFactor.generate_otp
    url = URI("http://2factor.in/API/V1/#{API_KEY}/SMS/#{phone_no}/#{otp}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    response = http.request(request)
    [JSON.parse(response.read_body), otp]
  end

  def self.generate_otp
    SecureRandom.random_number(100000)
  end
end