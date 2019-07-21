class AuthenticationController < ApplicationController
  # POST /customers/login
  def login
    if params[:email]
      @customer = Customer.find_by_email(params[:email])
      if @customer == nil
        raise Error::CustomError.error(401, :USR_01, "authentication")
      end
      if params[:password]
        begin 
          customer_password = BCrypt::Password.new(@customer.password)
        rescue
          raise Error::CustomError.error(500, :ISE, "authentication")
        end
        if customer_password == params[:password]
          create_and_display_customer_credentials(@customer)
        else
          raise Error::CustomError.error(401, :USR_01, "authentication")
        end
      else
        raise Error::CustomError.error(422, :USR_02, "password")
      end

    else
      raise Error::CustomError.error(422, :USR_02, "email")
    end
  end

  # POST /customers/facebook
  def facebook_login
    facebook_access_token = params.require(:access_token)
    if !facebook_access_token
      raise Error::CustomError.error(401, :USR_01, "authentication")
    end

    begin 
      graph = Koala::Facebook::API.new(facebook_access_token)
      profile = graph.get_object('me', fields: ['name', 'email'])
    rescue
      raise Error::CustomError.error(401, :USR_01, "authentication")
    end

    @customer = Customer.find_or_create_with_facebook_access_token(profile)
  
    if @customer && @customer.persisted?
      create_and_display_customer_credentials(@customer)
    else
      raise Error::CustomError.error(500, :ISE, "authentication")
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def login_params
      params.permit(:authentication, :email, :password)
    end
end