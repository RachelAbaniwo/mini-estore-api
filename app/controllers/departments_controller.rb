class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show]

  # GET /departments
  def index
    begin
      @departments = Department.all
    rescue
      raise Error::CustomError.error(500, :ISE, "department")
    end

    render json: @departments, status: 200
  end

  # GET /departments/{department_id}
  def show
    render json: @department, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      raise Error::CustomError.error(422, :DEP_01, "department") unless Number.is_integer?(params[:department_id])

      begin
        @department = Department.find(params[:department_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :DEP_02, "department")
      rescue
        raise Error::CustomError.error(500, :ISE, "department")
      end
      
    end
end
