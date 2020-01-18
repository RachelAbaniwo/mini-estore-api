module Authorize
  def self.create_token(customer_id)
    expiration_in_hours = 24
    time = expiration_in_hours.to_i
    begin
      token = JsonWebToken.encode(customer_id: customer_id)
      return {
        token: "Bearer " + "#{token}", 
        exp: "#{time}"+"h"
      }
    rescue 
      raise Error::CustomError.error(500, :ISE, "jwt-token")
    end
  end
  def self.authorize_request(header)
    header = header["USER-KEY"]

    if header
      user_header = header.split(' ').last
    else
      raise Error::CustomError.error(401, :AUT_01, "authorization")
    end
    begin
      @decoded = JsonWebToken.decode(user_header)
      return Customer.find(@decoded[:customer_id])
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(401, :AUT_02, "authorization")
    rescue JWT::DecodeError
      raise Error::CustomError.error(401, :AUT_02, "authorization")
    rescue
      raise Error::CustomError.error(500, :ISE, "authorization")
    end
  end
end