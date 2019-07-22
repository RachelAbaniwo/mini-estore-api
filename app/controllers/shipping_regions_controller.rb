class ShippingRegionsController < ApplicationController
  before_action :set_shipping_region, only: [:show]

  # GET /shipping/regions
  def index
    begin
      @shipping_regions = ShippingRegion.all
    rescue
      raise Error::CustomError.error(500, :ISE, "shipping_regions")
    end

    render json: @shipping_regions, status: 200
  end

  # GET /shipping/regions/{shipping_region_id}
  def show
    @shippings = @shipping_region.shippings

    render json: @shippings, status: 200
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipping_region
      raise Error::CustomError.error(422, :SHI_01, "shipping_region") unless Number.is_integer?(params[:shipping_region_id])
      begin
        @shipping_region = ShippingRegion.find(params[:shipping_region_id])
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :SHI_02, "shipping_region")
      rescue
        raise Error::CustomError.error(500, :ISE, "shipping_region")
      end
    end

end
