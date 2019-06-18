require 'rails_helper'

describe "Attributes API", :type => :request do

  attributes = Attribute.all
  attribute_count = attributes.size
  first_attribute = attributes.first
  first_attribute_id = first_attribute.id
  last_attribute_id = attributes.last.id
  attribute_not_found = last_attribute_id + 1
  products = Product.all
  first_product = products.first
  first_product_id = first_product.id

  it "it retrieves all attributes" do

    get attributes_path
    expect(response).to be_successful
    expect(json.size).to eq(attribute_count)
    expect(json[0]["attribute_id"]).to eq(first_attribute_id)
    expect(json[0]["name"]).to eq(first_attribute.name)
  end

  it "retrieves a specific attribute" do

    get "/attributes/#{first_attribute_id}"
    expect(json["attribute_id"]).to eq(first_attribute_id)
    expect(json["name"]).to eq(first_attribute.name)
  end

  it "returns appropriate error message if the attribute ID params passed to get a specific attribute is not found" do

    get "/attributes/#{attribute_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("ATT_02")
    expect(error["message"]).to eq("Don't exist attribute with this ID.")
    expect(error["field"]).to eq("attribute")
  end

  it "returns appropriate error message if the attribute ID \
params passed to get a specific attribute is not a valid integer" do

    get "/attributes/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("ATT_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("attribute")
  end

  it "retrieves the values of an attribute" do
    first_attribute_values = first_attribute.attribute_values
    first_attribute_values_count = first_attribute_values.size
    first_value = first_attribute_values.first

    get "/attributes/values/#{first_attribute_id}"
    expect(json.size).to eq(first_attribute_values_count)
    expect(json[0]["attribute_value_id"]).to eq(first_value.id)
    expect(json[0]["value"]).to eq(first_value.value)
  end

  it "returns appropriate error message if the attribute ID \
params passed to get a specific attribute\'s values is not found" do

    get "/attributes/values/#{attribute_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("ATT_02")
    expect(error["message"]).to eq("Don't exist attribute with this ID.")
    expect(error["field"]).to eq("attribute")
  end

  it "returns appropriate error message if the attribute ID \
params passed to get a specific attribute\'s values is not a valid integer" do

    get "/attributes/values/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("ATT_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("attribute")
  end

  it "retrieves the attributes of a product" do
    attribute_values = first_product.attribute_values
    attribute_values_count = attribute_values.size
    first_attribute_value = attribute_values.first

    get "/attributes/inProduct/#{first_product_id}"
    expect(response).to be_successful
    expect(json.size).to eq(attribute_values_count)
    expect(json[0]["attribute_value_id"]).to eq(first_attribute_value.id)
    expect(json[0]["attribute_value"]).to eq(first_attribute_value.value)
  end

  it "returns appropriate error message if the product ID \
params passed to get attributes for a product, is not found" do
    last_product_id = products.last.id
    product_not_found = last_product_id + 1

    get "/attributes/inProduct/#{product_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("PRO_02")
    expect(error["message"]).to eq("Don't exist product with this ID.")
    expect(error["field"]).to eq("product")
  end

  it "returns appropriate error message if the product ID \
  params passed to get attributes for a product, is not a valid integer" do

    get "/attributes/inProduct/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PRO_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("product")
  end

end