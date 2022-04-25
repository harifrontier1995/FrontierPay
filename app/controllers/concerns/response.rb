module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def json_error_response message, status = 400
  	response = {status: 'error', message: message}
  	render json: response, status: status
  end
end