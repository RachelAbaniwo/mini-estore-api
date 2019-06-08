class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  def index
    order = params[:order] ? params[:order] : 'category_id,ASC'
    order_arr = order.split(",")
    column = ["category_id", "name"]
    order_by = ["ASC","DESC"]
    if (order.include? ",") && ! (order.include? " ") && 
      (order_arr.length == 2) && (order_arr[1] == order_arr[1].upcase) && 
      (order_by.any?{|substr| order_arr[1].include?(substr)})
      
      if (column.any?{|substr| order_arr[0].include?(substr)}) 
        order_string = order
        order_string.tr!(',', ' ') 
        limit = Number.is_integer?(params[:limit]) ? params[:limit] : 20
        page = Number.is_integer?(params[:page]) ? params[:page] : 1
        offset = (page.to_i - 1) * limit.to_i

        begin
          @categories = Category.all.order(order_string).offset(offset).limit(limit)
        rescue
          raise Error::CustomError.error(500, :ISE, "category")
        end

        categories = {
          count: @categories.except(:offset, :limit, :order).count,
          rows: @categories
        }

        render json: categories, status: 200
      else
        raise Error::CustomError.error(422, :PAG_02, "category")
      end
    else
      raise Error::CustomError.error(422, :PAG_01, "category")
    end

  end

  # GET /categories/{category_id}
  def show
    render json: @category, status: 200
  end

  # GET /categories/inProduct/{product_id}
  def get_product_category
    raise Error::CustomError.error(422, :PRO_01, "product") unless Number.is_integer?(params[:product_id])

    begin
      @product = Product.find(params[:product_id])
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :PRO_02, "product")
    rescue
      raise Error::CustomError.error(500, :ISE, "product")
    end

    begin
      @category = ProductCategory.where(product_id: @product.id).first.category
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :PRO_03, "category")
    rescue
      raise Error::CustomError.error(500, :ISE, "category")
    end

    category = [{
      category_id: @category.id,
      department_id: @category.department_id,
      name: @category.name
    }]

    render json: category, status: 200
  end

  # GET /category/inDepartment/{department_id}
  def get_department_categories
    raise Error::CustomError.error(422, :DEP_01, "department") unless Number.is_integer?(params[:department_id])

    begin
      @department = Department.find(params[:department_id])
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :DEP_02, "department")
    rescue
      raise Error::CustomError.error(500, :ISE, "department")
    end
    
    @categories = @department.categories.all

    render json: @categories, status: 200
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      raise Error::CustomError.error(422, :CAT_02, "category") unless Number.is_integer?(params[:category_id])
      begin
        @category = Category.find(params[:category_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :CAT_01, "category")
      rescue
        raise Error::CustomError.error(500, :ISE, "category")
      end
    end

end
