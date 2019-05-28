class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # GET /categories/{category_id}
  def show
    render json: @category
  end

  # GET /categories/inProduct/{product_id}
  def get_product_category
    @product = Product.find(params[:product_id])
    @category = ProductCategory.where(product_id: @product.id).first.category 

    category = [{
      category_id: @category.id,
      department_id: @category.department_id,
      name: @category.name
    }]

    render json: category
  end
  # GET /category/inDepartment/{department_id}
  def get_department_categories
    @department = Department.find(params[:department_id])
    @categories = @department.categories.all

    render json: @categories
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

end
