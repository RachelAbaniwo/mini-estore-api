class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :get_product_details, :get_product_locations]

  # GET /products
  def index
    limit = Number.is_integer?(params[:limit]) ? params[:limit] : 20
    page = Number.is_integer?(params[:page]) ? params[:page] : 1
    offset = (page.to_i - 1) * limit.to_i

    begin
      @products = Product.all.offset(offset).limit(limit)
    rescue
      raise Error::CustomError.error(500, :ISE, "product")
    end

    products = {
      count: @products.except(:offset, :limit).count,
      rows: @products
    }
    
    render json: products, status: 200
  end

  # GET /products/search
  def search_products
    search_string = params[:query_string] if params[:query_string]
    if search_string.include?('"')
      search_params = search_string.tr('"',"'")
    else
      search_params = search_string
    end
    all_words = params[:all_words] ? params[:all_words] : "on"
    
    description_length = Number.is_integer?(params[:description_length]) ? params[:description_length] : 200
    limit = Number.is_integer?(params[:limit]) ? params[:limit] : 20
    page = Number.is_integer?(params[:page]) ? params[:page] : 1
    offset = (page.to_i - 1) * limit.to_i

    
    if all_words = "on"
      query = %Q(SELECT SQL_CALC_FOUND_ROWS product_id, name,
            IF(LENGTH(description) <= #{description_length},
            description,
            CONCAT(LEFT(description, #{description_length}),
                    '...')) AS description,
            price, discounted_price, thumbnail
            FROM     product
            WHERE    MATCH(name, description) AGAINST("%#{search_params}%" IN BOOLEAN MODE)
            ORDER BY MATCH(name, description) AGAINST("%#{search_params}%" IN BOOLEAN MODE) DESC
            LIMIT    #{offset}, #{limit})
    else
      query = %Q(SELECT product_id, name,
            IF(LENGTH(description) <= #{description_length},
            description,
            CONCAT(LEFT(description, #{description_length}),
                    '...')) AS description,
            price, discounted_price, thumbnail
            FROM     product
            WHERE    MATCH(name, description) AGAINST('%#{search_params}%')
            LIMIT    #{offset}, #{limit})
    end

    begin
      @products = ActiveRecord::Base.connection.exec_query(query)
      @count = ActiveRecord::Base.connection.exec_query("SELECT FOUND_ROWS()")
    rescue
      raise Error::CustomError.error(500, :ISE, "product")
    end
    ActiveRecord::Base.clear_active_connections!

    products = {
      count: @count[0].values[0],
      rows: @products
    }
    render json: products, status: 200
  end

  # GET /products/{product_id}
  def show
    render json: @product, status: 200
  end

  # GET /products/inCategory/{category_id}
  def get_products_in_category
    raise Error::CustomError.error(422, :CAT_02, "category") unless Number.is_integer?(params[:category_id])
    begin
      @category = Category.find(params[:category_id])
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :CAT_01, "category")
    rescue
      raise Error::CustomError.error(500, :ISE, "category")
    end
    @products = @category.products

    render json: @products, status: 200
  end

  # GET /products/inDepartment/{department_id}
  def get_products_in_department
    raise Error::CustomError.error(422, :DEP_01, "department") unless Number.is_integer?(params[:department_id])
    begin
      @categories = Department.find(params[:department_id]).categories
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :DEP_02, "department")
    rescue
      raise Error::CustomError.error(500, :ISE, "department")
    end

    @products = []
    @categories.map do |category|
      product = category.products
      (@products << product).flatten!
    end

    render json: @products, status: 200
  end

  # GET /products/{product_id}/details
  def get_product_details
    product_details = [{
      product_id: @product.id,
      name: @product.name,
      description: @product.description,
      price: @product.price,
      discounted_price: @product.discounted_price,
      image: @product.image,
      image_2: @product.image_2
    }]

    render json: product_details, status: 200
  end

  # GET /products/{product_id}/locations
  def get_product_locations
    begin
      @category = ProductCategory.where(product_id: @product.id).first.category
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :PRO_03, "category")
    rescue
      raise Error::CustomError.error(500, :ISE, "category")
    end

    product_locations = [{
      category_id: @category.id,
      category_name: @category.name,
      department_id: @category.department_id,
      department_name: @category.department.name
    }]

    render json: product_locations, status: 200
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      raise Error::CustomError.error(422, :DEP_01, "department") unless Number.is_integer?(params[:product_id])

      begin
        @product = Product.find(params[:product_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :PRO_02, "product")
      rescue
        raise Error::CustomError.error(500, :ISE, "product")
      end

    end
end
