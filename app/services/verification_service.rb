class VerificationService
  def initialize(phone_number, country_code="+91")
    @phone_number = phone_number
    @country_code = country_code
    @account_sid = Rails.application.credentials.ACCOUNT_SID
    @auth_token = Rails.application.credentials.AUTH_TOKEN
    @service_sid = Rails.application.credentials.SERVICE_SID

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