class AttributesController < ApplicationController
  before_action :set_attribute, only: [:show, :get_attribute_values]

  # GET /attributes
  def index
    begin
      @attributes = Attribute.all
    rescue
      raise Error::CustomError.error(500, :ISE, "attribute")
    end

    render json: @attributes, status: 200
  end

  # GET /attributes/{attribute_id}
  def show
      render json: @attribute, status: 200
  end

  # GET /attributes/values/{attribute_id}
  def get_attribute_values
    @attribute_values = @attribute.attribute_values
    values = []
    @attribute_values.map do |attribute_value|
      value = {
        attribute_value_id: attribute_value.id,
        value: attribute_value.value
      }
      values << value
    end
    render json: values, status: 200
  end

  # GET /attributes​/inProduct​/{:product_id}
  def get_product_attributes
    raise Error::CustomError.error(422, :PRO_01, "product") unless Number.is_integer?(params[:product_id])
    begin 
      @attribute_values = Product.find(params[:product_id]).attribute_values
    rescue ActiveRecord::RecordNotFound
      raise Error::CustomError.error(404, :PRO_02, "product")
    rescue
      raise Error::CustomError.error(500, :ISE, "attribute")
    end
    product_attributes = []
    @attribute_values.map do |attribute_value|
      product_attribute = {
        attribute_name: Attribute.find(attribute_value.attribute_id).name,
        attribute_value_id: attribute_value.id,
        attribute_value: attribute_value.value
      }
      product_attributes << product_attribute
    end
     render json: product_attributes, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute
      raise Error::CustomError.error(422, :ATT_01, "attribute") unless Number.is_integer?(params[:attribute_id])
      begin
        @attribute = Attribute.find(params[:attribute_id]) 
      rescue ActiveRecord::RecordNotFound
        raise Error::CustomError.error(404, :ATT_02, "attribute")
      rescue
        raise Error::CustomError.error(500, :ISE, "attribute")
      end
    end
end
