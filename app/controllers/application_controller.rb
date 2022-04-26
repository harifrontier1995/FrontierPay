class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  # called before every action on controllers
  before_action :validate_app_key
  before_action :authorize_request, except: [:send_code, :create]
  attr_reader :current_user

  
  private

  # Check for valid request token and return user
  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def serialize_data data
    ActiveModel::SerializableResource.new(data).as_json
  end

   #check for valid app key
  def validate_app_key
    (AuthorizeApiRequest.new(request.headers).verify_app_key)
  end
end
