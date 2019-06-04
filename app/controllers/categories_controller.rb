class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  def index
    order = params[:order] ? params[:order] : 'category_id,ASC'
    order_arr = order.split(",")
    if (order.include? ",") && ! (order.include? " ") && (order_arr.length == 2) && (order_arr[1] == order_arr[1].upcase)
      column = ["category_id", "name"]
      order_by = ["ASC","DESC"]
      if (column.any?{|substr| order_arr[0].include?(substr)}) && (order_by.any?{|substr| order_arr[1].include?(substr)})
        order_string = order
        order_string.tr!(',', ' ') 
        limit = params[:limit] ? params[:limit] : 20
        page = params[:page] ? params[:page] : 1
        offset = (page.to_i - 1) * limit.to_i
        all_categories = Category.all
        @categories = Category.all.order(order_string).offset(offset).limit(limit)
        categories = {
          count: all_categories.length,
          rows: @categories
        }

        render json: categories
      else
        return puts"error3"
      end
    else
      return puts"error2"
    end

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
