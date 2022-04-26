class AuthenticateUser
  def initialize(phone_number, country_code)
    @phone_number = phone_number
    @country_code = country_code
  end

  # Service entry point
  def call
    if user
      token = JsonWebToken.encode(user_id: user.id)
      user.api_token ? user.api_token.save_token(token) :
                       user.build_api_token.save_token(token)
      [token, user]
    end
  end

  private

  attr_reader :phone_number, :country_code

  # verify otp
  def user
    user = User.find_by(phone_number: phone_number)
    return user if user && verify_otp_code?
    # raise Authentication error if credentials are invalid
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end

  def verify_otp_code?
    VerificationService.new(
      phone_number,
      country_code
    ).verify_otp_code?(params['otp_code'])
  end
end