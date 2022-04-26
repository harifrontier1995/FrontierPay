module Response
  def json_response(object, status = :ok)
    render json: {status: 'success', data: object}, status: status
  end

  def json_error_response message, status = 400
  	response = {status: 'error', data: { error: message }}
  	render json: response, status: status
  end
end