module AuthValidation
  def check_errors(errors)
    if errors.added?(:email, "is invalid") && !errors.added?(:email, :blank)
      raise Error::CustomError.error(422, :USR_03, "email")
    end
    if errors.added?(:name, :blank) || errors.added?(:password, :blank) || errors.added?(:email, :blank)
      blank_fields = ""
      if errors.added?(:name, :blank)
        blank_fields << "name"
      end
      if errors.added?(:email, :blank)
        email = blank_fields == "" ? "email" : ", email"
        blank_fields << email
      end
      if errors.added?(:password, :blank)
        password = blank_fields == "" ? "password" : ", password"
        blank_fields << password
      end
      puts blank_fields
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end

    if errors.added?(:email, "has already been taken")
      raise Error::CustomError.error(422, :USR_04, "email")
    end
    if errors.added?(:password, "is too short (minimum is 6 characters)")
      raise Error::CustomError.error(422, :USR_10, "password")
    end
    if errors.added?(:name, "is too long (maximum is 50 characters)")
      raise Error::CustomError.error(422, :USR_07, "name")
    end
    if errors.added?(:email, "is too long (maximum is 255 characters)")
      raise Error::CustomError.error(422, :USR_07, "email")
    end
    if errors.added?(:day_phone, "is invalid")
      raise Error::CustomError.error(422, :USR_06, "day_phone")
    end
    if errors.added?(:eve_phone, "is invalid")
      raise Error::CustomError.error(422, :USR_06, "eve_phone")
    end
    if errors.added?(:mob_phone, "is invalid")
      raise Error::CustomError.error(422, :USR_06, "mob_phone")
    end
    if errors.added?(:credit_card, "is invalid")
      raise Error::CustomError.error(422, :USR_08, "credit_card")
    end
  end

  def check_address(address_params)
    if !address_params["address_1"] || address_params["address_1"].strip == "" ||
      !address_params["city"] || address_params["city"].strip == "" ||
      !address_params["region"] || address_params["region"].strip == "" ||
      !address_params["postal_code"] || address_params["postal_code"].strip == "" ||
      !address_params["country"] || address_params["country"].strip == "" ||
      !address_params["shipping_region_id"] || address_params["shipping_region_id"].strip == ""
    blank_fields = ""
      if !address_params["address_1"] || address_params["address_1"].strip == ""
        blank_fields << "address_1"
      end
      if !address_params["city"] || address_params["city"].strip == ""
        city = blank_fields == "" ? "city" : ", city"
        blank_fields << city
      end
      if !address_params["region"] || address_params["region"].strip == ""
        region = blank_fields == "" ? "region" : ", region"
        blank_fields << region
      end
      if !address_params["postal_code"] || address_params["postal_code"].strip == ""
        postal_code = blank_fields == "" ? "postal_code" : ", postal_code"
        blank_fields << postal_code
      end
      if !address_params["country"] || address_params["country"].strip == ""
        country = blank_fields == "" ? "country" : ", country"
        blank_fields << country
      end
      if !address_params["shipping_region_id"] || address_params["shipping_region_id"].strip == ""
        shipping_region_id = blank_fields == "" ? "shipping_region_id" : ", shipping_region_id"
        blank_fields << shipping_region_id
      end
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end
    if address_params["shipping_region_id"] && !address_params["shipping_region_id"].strip == "" && ! Number.is_integer?(address_params["shipping_region_id"])
      raise Error::CustomError.error(422, :USR_09, "shipping_region_id")
    end
  end

  def check_credit_card(cc_params)
    if !cc_params["credit_card"] || cc_params["credit_card"].strip == ""
      raise Error::CustomError.error(422, :USR_02, "credit_card")
    end
  end
  
  def check_item(params)
    carts = ShoppingCart.where(cart_id: params[:cart_id])
    if carts.length != 0
      available_product = nil
      carts.map do |cart|
        if cart.product_id.to_s == params[:product_id] && cart.attry == params[:attry]
          available_product = cart
        end
      end
      available_product 
    end
  end

  def check_cart_params(errors)
    if errors.added?(:cart_id, :blank) || errors.added?(:product_id, :blank) || errors.added?(:attry, :blank)
      blank_fields = ""
      if errors.added?(:cart_id, :blank)
        blank_fields << "cart_id"
      end
      if errors.added?(:product_id, :blank)
        product_id = blank_fields == "" ? "product_id" : ", product_id"
        blank_fields << product_id
      end
      if errors.added?(:attry, :blank)
        attribute = blank_fields == "" ? "attributes" : ", attributes"
        blank_fields << attribute
      end
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end

  end

  def check_review_params(errors)
    if errors.added?(:review, :blank) || errors.added?(:rating, :blank)
      blank_fields = ""
      if errors.added?(:review, :blank)
        blank_fields << "review"
      end
      if errors.added?(:rating, :blank)
        rating = blank_fields == "" ? "rating" : ", rating"
        blank_fields << rating
      end
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end
  end

  def check_order_params(errors, params)
    if ( !params[:cart_id] || params[:cart_id] == "" ) || errors.added?(:shipping_id, :blank) || errors.added?(:tax_id, :blank)
      blank_fields = ""
      if !params[:cart_id] || params[:cart_id] == ""
        blank_fields << "cart_id"
      end
      if errors.added?(:shipping_id, :blank)
        shipping_id = blank_fields == "" ? "shipping_id" : ", shipping_id"
        blank_fields << shipping_id
      end
      if errors.added?(:tax_id, :blank)
        tax_id = blank_fields == "" ? "tax_id" : ", tax_id"
        blank_fields << tax_id
      end
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end
  end

  def stripe_check(params)
    if ( !params[:amount] || params[:amount] == "" ) || 
      ( !params[:stripeToken] || params[:stripeToken] == "" ) || 
      ( !params[:description] || params[:description] == "" ) ||
      ( !params[:order_id] || params[:order_id] == "" )
      blank_fields = ""
      if !params[:amount] || params[:amount] == ""
        blank_fields << "amount"
      end
      if !params[:stripeToken] || params[:stripeToken] == ""
        stripeToken = blank_fields == "" ? "stripeToken" : ", stripeToken"
        blank_fields << stripeToken
      end
      if !params[:description] || params[:description] == ""
        description = blank_fields == "" ? "description" : ", description"
        blank_fields << description
      end
      if !params[:order_id] || params[:order_id] == ""
        order_id = blank_fields == "" ? "order_id" : ", order_id"
        blank_fields << order_id
      end
      raise Error::CustomError.error(422, :USR_02, blank_fields)
    end
  end
end