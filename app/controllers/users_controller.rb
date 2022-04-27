class UsersController < ApplicationController

  def create
    if verify_otp_code?
        user = User.find_or_create_by(
          country_code: user_params[:country_code],
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
      user_params[:phone_number],
      user_params[:country_code]
    ).verify_otp_code?(params['otp_code'])
  end

  def send_code
    response = VerificationService.new(
      user_params[:phone_number],
      user_params[:country_code]
    ).send_otp_code
    render json: { status: 'success', data: { message: response} }
  end

  def send_otp
    require 'uri'
    require 'net/http'

    url = URI("http://2factor.in/API/V1/8aadf038-c463-11ec-9c12-0200cd936042/SMS/9150968427/4499")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'

    response = http.request(request)
    
    render json: { status: 'success', data: { message: response.read_body} }
  end

  def verify_otp
    require 'uri'
    require 'net/http'

    url = URI("http://2factor.in/API/V1/8aadf038-c463-11ec-9c12-0200cd936042/SMS/VERIFY/158a615d-b91d-4ce4-8945-c9e2e62fffd7/4499")

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'

    response = http.request(request)
    
    render json: { status: 'success', data: { message: response.read_body} }
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
