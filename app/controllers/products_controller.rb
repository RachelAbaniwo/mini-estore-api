class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :get_product_details]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/{product_id}
  def show
    render json: @product
  end

  # GET /products/inCategory/{category_id}
  def get_products_in_category
    @category = Category.find(params[:category_id])
    @products = @category.products

    render json: @products
  end

  # GET /products/inDepartment/{department_id}
  def get_products_in_department
    @categories = Department.find(params[:department_id]).categories
    @products = []
    @categories.map do |category|
      product = category.products
      (@products << product).flatten!
    end

    render json: @products
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

    render json: product_details
  end

  # GET /products/{product_id}/locations
  def get_product_locations
    @category = ProductCategory.where(product_id: params[:product_id]).first.category 
    product_locations = [{
      category_id: @category.id,
      category_name: @category.name,
      department_id: @category.department_id,
      department_name: @category.department.name
    }]

    render json: product_locations
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:product_id])
    end
end
