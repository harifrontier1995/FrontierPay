class UsersController < ApplicationController

  def create
    if verify_otp_code?
        user = User.find_or_create_by(
          phone_number: user_params[:phone_number]
        )
        token = JsonWebToken.encode(user_id: user.id)
        user.api_token ? user.api_token.save_token(token) : user.build_api_token.save_token(token)
        render json: {status: 'success',data:{ user: serialize_data(user), message: "Phone number Verified"},auth_token: token}
    else
      json_error_response 'Please enter a valid phone number.'
    end
  rescue Twilio::REST::RestError => e
    json_error_response 'otp code has expired. Resend code'
  end

  def verify_otp_code?
    VerificationService.new(
      user_params[:phone_number]
    ).verify_otp_code?(params['otp_code'])
  end

  def send_code
    response = VerificationService.new(
      user_params[:phone_number]
    ).send_otp_code
    render json: { status: 'success', data: { message: response} }
  end

  def update
    @current_user.update(user_params)
    json_response(user: serialize_data(@current_user))
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :country_code, :phone_number, :first_name, :last_name
    )
  end

 
end
