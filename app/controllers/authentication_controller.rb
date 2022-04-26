class AuthenticationController < ApplicationController

  skip_before_action :authorize_request, only: :authenticate

  # return auth token once user is authenticated
  def authenticate
    auth_token, user = AuthenticateUser.new(auth_params[:phone_number], auth_params[:country_code]).call
    render json: {status: 'success', message: Message.authentication_success, auth_token: auth_token, user: serialize_data(user)}
  end

  private

  def auth_params
    params.permit(:phone_number, :country_code)
  end
end