class VerificationService
  def initialize(phone_number, country_code)
    @phone_number = phone_number
    @country_code = country_code
    @account_sid = "ACba261530abf7a184a71e0cd92716a913"
    @auth_token = "e21e15337793b8253ad52458f39b4e39"
    @service_sid = "VA3897d8a3e095fe4e21782d02494d4d69"

    client = Twilio::REST::Client.new(@account_sid, @auth_token)
    @verification_service = client.verify.services(@service_sid)
    @phone_number_with_code = "#{@country_code}#{@phone_number}"
  end

  def send_otp_code
    @verification_service.verifications.create(to: @phone_number_with_code, channel: 'sms')
    'An activation code would be sent to your phonenumber!'
  end

  def verify_otp_code?(otp_code)
    verification_check =  @verification_service
                          .verification_checks
                          .create(to: @phone_number_with_code, code: otp_code)

    verification_check.status == 'approved'
  end


end