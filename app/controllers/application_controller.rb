class ApplicationController < ActionController::API
  include Authorize
  include AuthValidation
  include Error::ErrorHandler
  include Number
  
  

  def get_header
    header = request.headers
  end

  def create_and_display_customer_credentials(customer)
    token = Authorize.create_token(customer.id)
      header = get_header()
      header["USER-KEY"] = token[:token]
      customer_attributes = {
        customer: customer.attributes.except('password'),
        accessToken: token[:token],
        expires_in: token[:exp]
      }
      render json: customer_attributes, status: :created
  end
end
