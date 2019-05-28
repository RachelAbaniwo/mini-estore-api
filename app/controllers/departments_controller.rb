class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show]

  # GET /departments
  def index
    @departments = Department.all

    render json: @departments
  end

  # GET /departments/{department_id}
  def show
    render json: @department
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:department_id])
    end
end
