class ShoppingCartsController < ApplicationController
  before_action :set_shopping_cart, only: [:update, :save_for_later, :move_to_cart, :remove_cart_item]

  # GET /shoppingcart/generateUniqueId
  def generate_unique_id
    begin
      cart_id = SecureRandom.alphanumeric(18).downcase
    end while ShoppingCart.exists?(cart_id: cart_id)

    unique_cart_id = {
      cart_id: cart_id
    }

    render json: unique_cart_id, status: :created
    end

  # POST /shoppingcart/add
  def add
    if params[:product_id] && params[:product_id] != ""
      raise Error::CustomError.error(422, :PRO_01, "product") unless Number.is_integer?(params[:product_id])
    end
    params[:added_on] = Time.now

    if params[:product_id] && params[:cart_id] && params[:attributes]
      cart = check_item(shopping_cart_params)
    end
    if cart
      quantity = cart.quantity + 1
      params[:quantity] = quantity
      if cart.update(quantity: params[:quantity], added_on: params[:added_on])
        save_and_display_cart(params[:cart_id], :created)
      else
        if cart.errors
          errors = cart.errors
          check_cart_params(errors)
        else
          raise Error::CustomError.error(500, :ISE, "cart")
        end
      end
    else
      params[:quantity] = 1
      @shopping_cart = ShoppingCart.new(shopping_cart_params)

      if @shopping_cart.save
        save_and_display_cart(params[:cart_id], :created)
      else 
        if @shopping_cart.errors
          errors = @shopping_cart.errors
          check_cart_params(errors)
        else
          raise Error::CustomError.error(500, :ISE, "cart")
        end
      end
    end
  end

  # GET /shoppingcart/{cart_id}
  def show
    save_and_display_cart(params[:cart_id], 200)
  end

  def save_and_display_cart(shopping_cart_id, status)
    begin
      carts = ShoppingCart.where(cart_id: shopping_cart_id)
        
        shopping_carts = []
        carts.map do |cart|
          begin
            product = Product.find(cart.product_id)
          rescue
            raise Error::CustomError.error(500, :ISE, "product")
          end
          shopping_cart = {
            item_id: cart.item_id,
            name: product.name,
            attributes: cart.attry,
            product_id: cart.product_id,
            image: product.image,
            price: product.price,
            quantity: cart.quantity,
            subtotal: cart.quantity * product.price
          }

          shopping_carts << shopping_cart
        end
      render json: shopping_carts, status: status
    rescue
      raise Error::CustomError.error(500, :ISE, "cart")
    end
    
  end

  # PUT /shoppingcart/update/{item_id}
  def update
    update_params = params.permit(:quantity, :item_id)
    if params[:quantity] && params[:quantity] != ""
      raise Error::CustomError.error(422, :CAR_03, "quantity") unless Number.is_integer?(params[:quantity])
      if @shopping_cart_item.update(update_params)
        begin
          product = Product.find(@shopping_cart_item.product_id)
        rescue
          raise Error::CustomError.error(500, :ISE, "product")
        end
        shopping_cart_item = {
          item_id: @shopping_cart_item.item_id,
          name: product.name,
          attributes: @shopping_cart_item.attry,
          product_id: @shopping_cart_item.product_id,
          image: product.image,
          price: product.price,
          quantity: @shopping_cart_item.quantity,
          subtotal: @shopping_cart_item.quantity * product.price
        }
        render json: shopping_cart_item, status: 200
      else
        if @shopping_cart_item.errors
          errors = @shopping_cart_item.errors
          check_cart_params(errors)
        else
          raise Error::CustomError.error(500, :ISE, "cart")
        end
      end
    else
      raise Error::CustomError.error(422, :USR_02, "quantity")
    end
  end

  # DELETE /shoppingcart/empty/{cart_id}
  def destroy
    delete_params = params.permit(:cart_id)
    begin
      carts = ShoppingCart.where(cart_id: params[:cart_id])
    rescue
      raise Error::CustomError.error(500, :ISE, "cart")
    end
    
    carts.map do |cart|
      begin
        cart.destroy
      rescue
        raise Error::CustomError.error(500, :ISE, "cart")
      end 
    end
    render json: [], status: 200

  end

  # GET /shoppingcart​/saveForLater/{item_id}
  def save_for_later
    if @shopping_cart_item.update(buy_now: false)
      render json: { message: "saved for later" }, status: 200
    else
      raise Error::CustomError.error(500, :ISE, "cart")
    end
  end

  # GET /shoppingcart​/moveToCart​/{item_id}
  def move_to_cart
    if @shopping_cart_item.update(buy_now: true)
      render json: { message: "moved to cart" }, status: 200
    else
      raise Error::CustomError.error(500, :ISE, "cart")
    end
  end

  # GET /shoppingcart/totalAmount/{cart_id}
  def total_amount
    begin
      carts = ShoppingCart.where(cart_id: params[:cart_id], buy_now: true)
    rescue
      raise Error::CustomError.error(500, :ISE, "cart")
    end
    total = 0
    carts.each do |cart|
      product = Product.find(cart.product_id)
      subtotal = cart.quantity * product.price
      total += subtotal
    end
    total_amount = { total_amount: total }
    render json: total_amount , status: 200
  end

  # GET /shoppingcart/getSaved/{cart_id}
  def get_saved
    begin
      carts = ShoppingCart.where(cart_id: params[:cart_id], buy_now: false)
    rescue
      raise Error::CustomError.error(500, :ISE, "cart")
    end
    shopping_carts = []
    carts.map do |cart|
      product = Product.find(cart.product_id)
      shopping_cart = {
        item_id: cart.item_id,
        name: product.name,
        attributes: cart.attry,
        price: product.price
      }

      shopping_carts << shopping_cart
    end
    render json: shopping_carts, status: 200
  end

  # DELETE /shoppingcart/removeProduct/{item_id}
  def remove_cart_item
    begin
      @shopping_cart_item.destroy
    rescue
      raise Error::CustomError.error(500, :ISE, "cart")
    end
    render json: { message: "successfully removed item from cart " }, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      raise Error::CustomError.error(422, :CAR_02, "cart") unless Number.is_integer?(params[:item_id])
      begin
        @shopping_cart_item = ShoppingCart.find(params[:item_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :CAR_01, "cart")
      rescue
        raise Error::CustomError.error(500, :ISE, "cart")
      end
    end

    # Only allow a trusted parameter "white list" through.
    def shopping_cart_params
      params.tap { |p| p[:attry] = p[:attributes] }.permit(:shopping_cart, :cart_id, :product_id, :attry, :quantity, :added_on)
    end
end
