require "stripe"
class BillingsController < ApplicationController

  # POST stripe/charge
  def charge
    stripe_check(params)
    raise Error::CustomError.error(422, :STR_02, "charge amount") unless Number.is_integer?(params[:amount])

    begin
      stripe_response = Stripe::Charge.create({
                          amount: params[:amount],
                          currency: params[:currency],
                          source: params[:stripeToken],
                          description: params[:description]
                        })

    rescue Stripe::CardError
      raise Error::CustomError.error(422, :STR_01, "stripe charge")
    rescue
      raise Error::CustomError.error(500, :ISE, "stripe charge")
    end 

    if stripe_response
      raise Error::CustomError.error(422, :ORD_01, "order") unless Number.is_integer?(params[:order_id])
      begin
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :ORD_02, "order")
      rescue
        raise Error::CustomError.error(500, :ISE, "tax")
      end
      if @order.update(status: 1)
        render json: { message: "order status updated" }, status: :created
      else
        raise Error::CustomError.error(500, :ISE, "order status")
      end
    end
  end

end
