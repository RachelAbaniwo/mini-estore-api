require 'rails_helper'

describe "Products API" do
  default_limit = 20
  default_page_number = 1
  default_description_length = 200
  products = Product.all
  products_count = products.size
  first_product = products.first
  first_product_id = first_product.id
  first_product_name = first_product.name
  last_product_id = products.last.id
  product_not_found = last_product_id + 1
  categories = Category.all
  first_category = categories.first
  first_category_id = first_category.id
  departments = Department.all
  first_department = departments.first
  first_department_id = first_department.id


  it "retrieves all products and displays them with default count \
per page and page number when these are not specified" do
    current_page_count = paginator(products_count, default_limit, default_page_number)
    get products_path
    
    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(products_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (default_description_length + 3)
  end

  it "retrieves all products and displays them with default count \
per page and page number when these are not valid integers" do
    limit = "d"
    page_number = "d"
    description_length = "d"
    get "/products?limit=#{limit}&page=#{page_number}&description_length=#{description_length}"
    current_page_count = paginator(json["count"], default_limit, default_page_number)
    
    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(products_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (default_description_length + 3)
  end

  it "retrieves all products and displays them with accurate count \
per page and page number when these are specified" do
    limit = 5
    page_number = 10
    description_length = 15
    get "/products?limit=#{limit}&page=#{page_number}&description_length=#{description_length}"
    current_page_count = paginator(json["count"], limit, page_number)
    
    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(products_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (description_length + 3) if json["rows"][0]
  end

  it "searches for products with name or/and description that matches search \
params with default count per page and page number when these are not specified" do
    get "/products/search?query_string=#{first_product_name}"
    current_page_count = paginator(json["count"], default_limit, default_page_number)

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["rows"][0]["name"]).to eq(first_product_name)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (default_description_length + 3)
  end

  it "searches for products with name or/and description that matches search \
params with default count per page and page number when these are not valid integers" do
    limit = "d"
    page_number = "d"
    description_length = "d"
    get "/products/search?query_string=#{first_product_name}&limit=#{limit}&page=#{page_number}&description_length=#{description_length}"
    current_page_count = paginator(json["count"], default_limit, default_page_number)

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["rows"][0]["name"]).to eq(first_product_name)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (default_description_length + 3)
  end

  it "searches for products with name or/and description that matches search \
params with accurate count per page and page number when these are specified" do
    limit = 5
    page_number = 10
    description_length = 15
    get "/products/search?query_string=#{first_product_name}&limit=#{limit}&page=#{page_number}&description_length=#{description_length}"
    current_page_count = paginator(json["count"], limit, page_number)

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["description"].length).to be <= (description_length + 3) if json["rows"][0]
  end

  it "retrieves a specific product" do
    get "/products/#{first_product_id}"

    expect(response).to be_successful
    expect(json["product_id"]).to eq(first_product.id)
    expect(json["name"]).to eq(first_product.name)
    expect(json["description"]).to eq(first_product.description)
    expect(json["price"]).to eq(first_product.price.to_s)
    expect(json["discounted_price"]).to eq(first_product.discounted_price.to_s)
    expect(json["image"]).to eq(first_product.image)
    expect(json["image_2"]).to eq(first_product.image_2)
    expect(json["thumbnail"]).to eq(first_product.thumbnail)
    expect(json["display"]).to eq(first_product.display)
  end

  it "returns appropriate error message if the product ID params passed to get a specific product is not found" do

    get "/products/#{product_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("PRO_02")
    expect(error["message"]).to eq("Don't exist product with this ID.")
    expect(error["field"]).to eq("product")
  end

  it "returns appropriate error message if the product ID params passed to get a specific product is not an integer" do
    get "/products/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PRO_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("product")
  end

  it "returns the products in a category" do
    products_list = first_category.products
    first_category_product = products_list.first
    products_list_count = products_list.size
    get "/products/inCategory/#{first_category_id}"

    expect(response).to be_successful
    expect(json.size).to eq(products_list_count)
    expect(json[0]["product_id"]).to eq(first_category_product.id)
    expect(json[0]["name"]).to eq(first_category_product.name)
    expect(json[0]["description"]).to eq(first_category_product.description)
    expect(json[0]["price"]).to eq(first_category_product.price.to_s)
    expect(json[0]["discounted_price"]).to eq(first_category_product.discounted_price.to_s)
    expect(json[0]["image"]).to eq(first_category_product.image)
    expect(json[0]["image_2"]).to eq(first_category_product.image_2)
    expect(json[0]["thumbnail"]).to eq(first_category_product.thumbnail)
    expect(json[0]["display"]).to eq(first_category_product.display)
  end

  it "returns appropriate error message if the category ID params passed \
to get the products of a specific category is not found" do
    last_category_id = categories.last.id
    category_not_found = last_category_id + 1

    get "/products/inCategory/#{category_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("CAT_01")
    expect(error["message"]).to eq("Don't exist category with this ID.")
    expect(error["field"]).to eq("category")
  end

  it "returns appropriate error message if the category ID params passed \
to get the products of a specific category is not a valid integer" do

    get "/products/inCategory/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("CAT_02")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("category")
  end
  
  it "returns the products in a department" do
    first_department = first_category.department
    first_department_id = first_department.id
    department_categories = first_department.categories
    first_category_product = department_categories.first.products.first
    get "/products/inDepartment/#{first_department_id}"

    expect(response).to be_successful
    expect(json[0]["product_id"]).to eq(first_category_product.id)
    expect(json[0]["name"]).to eq(first_category_product.name)
    expect(json[0]["description"]).to eq(first_category_product.description)
    expect(json[0]["price"]).to eq(first_category_product.price.to_s)
    expect(json[0]["discounted_price"]).to eq(first_category_product.discounted_price.to_s)
    expect(json[0]["image"]).to eq(first_category_product.image)
    expect(json[0]["image_2"]).to eq(first_category_product.image_2)
    expect(json[0]["thumbnail"]).to eq(first_category_product.thumbnail)
    expect(json[0]["display"]).to eq(first_category_product.display)
  end

  it "returns appropriate error message if the ID params passed \
to get the products in a specific department is not found" do
    last_department_id = departments.last.id
    department_not_found = last_department_id + 1

    get "/products/inDepartment/#{department_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("DEP_02")
    expect(error["message"]).to eq("Don't exist department with this ID.")
    expect(error["field"]).to eq("department")
  end

  it "returns appropriate error message if the ID params passed \
to get the products in a specific department is not a valid integer" do

    get "/products/inDepartment/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("DEP_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("department")
  end

  it "returns a specific product\'s details" do
    
    get "/products/#{first_product_id}/details"
    expect(response).to be_successful
    expect(json[0]["product_id"]).to eq(first_product.id)
    expect(json[0]["name"]).to eq(first_product.name)
    expect(json[0]["description"]).to eq(first_product.description)
    expect(json[0]["price"]).to eq(first_product.price.to_s)
    expect(json[0]["discounted_price"]).to eq(first_product.discounted_price.to_s)
    expect(json[0]["image"]).to eq(first_product.image)
    expect(json[0]["image_2"]).to eq(first_product.image_2)
  end

  it "returns appropriate error message if the product ID \
params passed to get a specific product\'s details is not found" do

    get "/products/#{product_not_found}/details"
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
params passed to get a specific product\'s details is not an integer" do
    get "/products/d/details"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PRO_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("product")
  end

  it "returns a specific products\' locations" do
    products_list = first_category.products
    first_category_product = products_list.first
    first_category_product_id = first_category_product.id
    first_category_name = first_category.name
    first_category_department_id = first_category.department_id
    first_category_department_name = first_category.department.name


    get "/products/#{first_category_product_id}/locations"
    expect(response).to be_successful
    expect(json[0]["category_id"]).to eq(first_category_id)
    expect(json[0]["category_name"]).to eq(first_category_name)
    expect(json[0]["department_id"]).to eq(first_category_department_id)
    expect(json[0]["department_name"]).to eq(first_category_department_name)
  end

  it "returns appropriate error message if the product ID \
params passed to get a specific product\'s location is not found" do

    get "/products/#{product_not_found}/locations"
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
params passed to get a specific product\'s location is not an integer" do
    get "/products/d/locations"
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