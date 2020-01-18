class OrdersController < ApplicationController
  before_action :set_customer
  before_action :set_order, only: [:show, :order_detail]

  # GET /orders/inCustomer
  def index
    @orders = Order.where(customer_id: @customer.id)
      orders = []
      @orders.map do |order|
        order = {
          order_id: order.id,
          total_amount: order.total_amount,
          created_on: order.created_on,
          shipped_on: order.shipped_on,
          status: order.status,
          name: @customer.name
        }
        orders << order
      end

    render json: orders, status: 200
  end

  # GET /orders/{order_id}
  def show
    details = @order.order_details
    order_details = []
    details.map do |detail|
    order = {
      order_id: @order.id,
      product_id: detail.product_id,
      attributes: detail.attry,
      product_name: detail.product_name,
      quantity: detail.quantity,
      unit_cost: detail.unit_cost,
      subtotal: detail.quantity * detail.unit_cost
    }
      order_details << order
    end
      render json: order_details, status: 200
  end

  # GET /orders/shortDetail/{order_id}
  def order_detail
    order = {
      order_id: @order.id,
      total_amount: @order.total_amount,
      created_on: @order.created_on,
      shipped_on: @order.shipped_on,
      status: @order.status,
      name: @customer.name
    }
    render json: order, status: 200
  end

  # POST /orders
  def create
    params[:customer_id] = @customer.id

    if params[:tax_id] && params[:tax_id] != ""
      raise Error::CustomError.error(422, :TAX_01, "tax") unless Number.is_integer?(params[:tax_id])
    end
    if params[:shipping_id] && params[:shipping_id] != ""
      raise Error::CustomError.error(422, :SHI_03, "shipping") unless Number.is_integer?(params[:shipping_id])
    end
    if params[:cart_id] && params[:shipping_id].strip != ""
      carts = ShoppingCart.where(cart_id: params[:cart_id], buy_now: true)
      if carts.length == 0
        raise Error::CustomError.error(422, :CAR_01, "order")
      end
    end
    
    @order = Order.new(order_params)
    
    if @order.save
      order_id = @order.id
      total_amount = 0
      carts.map do |cart|
        begin
          product = Product.find(cart.product_id)
        rescue
          raise Error::CustomError.error(500, :ISE, "product")
        end
        @order_details = OrderDetail.new({
          item_id: cart.id,
          order_id: order_id,
          product_id: cart.product_id,
          attry: cart.attry,
          product_name: product.name,
          quantity: cart.quantity,
          unit_cost: product.price
        })
        total_cost = cart.quantity * product.price
        total_amount += total_cost
        if !@order_details.save
          raise Error::CustomError.error(500, :ISE, "order")
        end
      end
      Order.update({ total_amount: total_amount })
      order = {
        orderId: @order.id
      }
      render json: order, status: :created
    else
      if @order.errors
        errors = @order.errors
        check_order_params(errors, params)
      else
        raise Error::CustomError.error(500, :ISE, "order")
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      header = get_header()
      @customer = Authorize.authorize_request(header)
    end

    def set_order
      raise Error::CustomError.error(422, :ORD_01, "order") unless Number.is_integer?(params[:order_id])
      begin
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :ORD_02, "order")
      rescue
        raise Error::CustomError.error(500, :ISE, "tax")
      end
      
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.permit(:order, :customer_id, :shipping_id, :tax_id, :total_amount, :customer_id)
    end
end
