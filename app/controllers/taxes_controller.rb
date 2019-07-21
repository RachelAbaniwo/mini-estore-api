class TaxesController < ApplicationController
  before_action :set_tax, only: [:show]

  # GET /tax
  def index
    begin
      @taxes = Tax.all
    rescue
      raise Error::CustomError.error(500, :ISE, "tax")
    end

    render json: @taxes, status: 200
  end

  # GET /tax/{tax_id}
  def show
    render json: @tax, status: 200
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tax
      raise Error::CustomError.error(422, :TAX_01, "tax") unless Number.is_integer?(params[:tax_id])
      begin
        @tax = Tax.find(params[:tax_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :TAX_02, "tax")
      rescue
        raise Error::CustomError.error(500, :ISE, "tax")
      end
    end

end
