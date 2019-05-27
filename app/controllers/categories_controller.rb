class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # GET /category/inDepartment/{department_id}
  def get_department_categories
    @department = Department.find(params[:id])
    @categories = @department.categories.all
    render json: @categories
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

end
