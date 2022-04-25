class UsersController < ApplicationController
  def create
    if verify_otp_code?
        user = User.find_or_create_by(
          country_code: user_params[:country_code],
          phone_number: user_params[:phone_number]
        )
        token = JsonWebToken.encode(user_id: user.id)
        user.api_token ? user.api_token.save_token(token) : user.build_api_token.save_token(token)
        render json: {user: serialize_data(user),auth_token: token,message: 'Phone number verified!'}, status: :created
    else
      json_error_response 'Please enter a valid phone number.'
    end
  rescue Twilio::REST::RestError => e
    json_error_response 'otp code has expired. Resend code'
  end

  def verify_otp_code?
    VerificationService.new(
      user_params[:phone_number],
      user_params[:country_code]
    ).verify_otp_code?(params['otp_code'])
  end

  def send_code
    response = VerificationService.new(
      user_params[:phone_number],
      user_params[:country_code]
    ).send_otp_code

    render json: {
      phone_number: user_params[:phone_number],
      country_code: user_params['country_code'],
      message: response
    }
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :country_code, :phone_number
    )
  end
end
