class AttributesController < ApplicationController
  before_action :set_attribute, only: [:show, :get_attribute_values]

  # GET /attributes
  def index
    @attributes = Attribute.all

    render json: @attributes
  end

  # GET /attributes/{attribute_id}
  def show
    render json: @attribute
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
    render json: values
  end

  # GET /attributes​/inProduct​/{:product_id}
  def get_product_attributes
    @attribute_values = Product.find(params[:product_id]).attribute_values
    product_attributes = []
    @attribute_values.map do |attribute_value|
      product_attribute = {
        attribute_name: Attribute.find(attribute_value.attribute_id).name,
        attribute_value_id: attribute_value.id,
        attribute_value: attribute_value.value
      }
      product_attributes << product_attribute
    end
     render json: product_attributes
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attribute
      @attribute = Attribute.find(params[:attribute_id])
    end
end
