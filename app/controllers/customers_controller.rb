class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :update, :update_address, :update_credit_card]

  # GET /customer
  def show
    customer = {
      customer: @customer.attributes.except('password')
    }
    render json: customer, status: 200
  end

  # POST /customers
  def create
    begin
      @customer = Customer.new(customer_params)
    rescue
      raise Error::CustomError.error(500, :ISE, "authentication")
    end

    if @customer.save
      create_and_display_customer_credentials(@customer)
    else
      if @customer.errors
        errors = @customer.errors
        check_errors(errors)
      else
        raise Error::CustomError.error(500, :ISE, "authentication")
      end
    end
    
  end

  # PUT /customer
  def update
    if @customer.update(customer_update_params)
      customer = {
        customer: @customer.attributes.except('password')
      }
      render json: customer, status: 200
    else
      if @customer.errors
        puts @customer.errors.to_json
        errors = @customer.errors
        check_errors(errors)
      else
        raise Error::CustomError.error(500, :ISE, "authentication")
      end
    end
  end

  # PUT /customer/address
  def update_address
    address_params = params.permit(:customer, :address_1, :address_2, :city, :region, :postal_code, :country, :shipping_region_id)
     puts address_params
    check_address(address_params)
    if @customer.update(address_params)
      customer = {
        customer: @customer.attributes.except('password')
      }
      render json: customer, status: 200
    else
      if @customer.errors
        errors = @customer.errors
        check_errors(errors)
      else
        raise Error::CustomError.error(500, :ISE, "authentication")
      end
    end
  end

  # PUT /customer/creditCard
  def update_credit_card
    cc_params = params.permit(:customer, :credit_card)
     puts cc_params
     check_credit_card(cc_params)
    if @customer.update(cc_params)
      customer = {
        customer: @customer.attributes.except('password')
      }
      render json: customer, status: 200
    else
      if @customer.errors
        puts @customer.errors.to_json
        errors = @customer.errors
        check_errors(errors)
      else
        raise Error::CustomError.error(500, :ISE, "authentication")
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      header = get_header()
      @customer = Authorize.authorize_request(header)
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.permit(:customer, :name, :email, :password, :credit_card, :address_1, :address_2, :city, :region, :postal_code, :country, :shipping_region_id, :day_phone, :eve_phone, :mob_phone)
    end

    def customer_update_params
      params.permit(:customer, :name, :email, :password, :day_phone, :eve_phone, :mob_phone)
    end
end
