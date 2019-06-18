require 'rails_helper'

describe "Categories API", :type => :request do
  default_limit = 20
  default_page_number = 1
  default_order = 'category_id ASC'
  categories = Category.all
  category_count = categories.size
  first_category = categories.first
  first_category_id = first_category.id

  it "retrieves all categories and displays them with default count \
per page, page number and order when these are not specified " do
    current_page_count = paginator(category_count, default_limit, default_page_number)
    get categories_path

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(category_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["department_id"]).to be_truthy
    expect(response).to be_successful
    expect(json["rows"]).to eq(Category.all.order(default_order).as_json)
  end

  it "retrieves all categories and displays them with default count \
per page and page number when these are not valid integers" do
    limit = "d"
    page_number = "d"
    current_page_count = paginator(category_count, default_limit, default_page_number)
    get "/categories?limit=#{limit}&page=#{page_number}"

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(category_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["department_id"]).to be_truthy
    expect(response).to be_successful
    expect(json["rows"]).to eq(Category.all.order(default_order).as_json)
  end

  it "retrieves all categories and displays them with accurate count \
per page and page number these are specified" do
    limit = 5
    page_number = 10
    get "/categories?limit=#{limit}&page=#{page_number}"
    current_page_count = paginator(category_count, limit, page_number)

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(category_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["department_id"]).to be_truthy if json["rows"][0]
    expect(response).to be_successful
  end

  it "retrieves all categories and displays them with accurate \
order when this is specified" do
    order = "name,DESC"
    sort_order = order.tr(',', ' ')
    get "/categories?order=#{order}"
    current_page_count = paginator(category_count, default_limit, default_page_number)

    expect(json["count"]).to be_truthy
    expect(json["rows"]).to be_truthy
    expect(json["count"]).to eq(category_count)
    expect(json["rows"].size).to eq(current_page_count)
    expect(json["rows"][0]["department_id"]).to be_truthy
    expect(response).to be_successful
    expect(json["rows"]).to eq(Category.all.order(sort_order).as_json)
  end

  it "returns appropriate error message if the order params format passed is not valid" do
    order = "name asc"
    get "/categories?order=#{order}"
    
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PAG_01")
    expect(error["message"]).to eq("The order is not matched 'field,(DESC|ASC)'.")
    expect(error["field"]).to eq("category")
  end

  it "returns appropriate error message if the field to be ordered \
in the order params passed is not valid" do
    order = "nothing,DESC"
    get "/categories?order=#{order}"
    
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PAG_02")
    expect(error["message"]).to eq("The field of order is not allow sorting.")
    expect(error["field"]).to eq("category")
  end

  it "retrieves a specific category" do
    get "/categories/#{first_category_id}"

    expect(response).to be_successful
    expect(json["name"]).to eq(first_category.name)
    expect(json["description"]).to eq(first_category.description)
  end

  it "returns appropriate error message if the category ID params passed to get a specific category is not found" do
    last_category_id = categories.last.id
    category_not_found = last_category_id + 1

    get "/categories/#{category_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("CAT_01")
    expect(error["message"]).to eq("Don't exist category with this ID.")
    expect(error["field"]).to eq("category")
  end

  it "returns appropriate error message if the category ID params passed to get a specific category is not an integer" do
    get "/categories/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("CAT_02")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("category")
  end

  it "retrieves a product\'s category" do
    products = first_category.products
    product_id = products.first.id
    get "/categories/inProduct/#{product_id}"

    expect(response).to be_successful
    expect(json.first["name"]).to eq(first_category.name)
    expect(json.first["department_id"]).to eq(first_category.department_id)
  end

  it "returns appropriate error message if the product ID params passed to get a product\'s category is not found" do
    products = Product.all
    last_product_id = products.last.id
    product_not_found = last_product_id + 1

    get "/categories/inProduct/#{product_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("PRO_02")
    expect(error["message"]).to eq("Don't exist product with this ID.")
    expect(error["field"]).to eq("product")
  end

  it "returns appropriate error message if the product ID params passed to get a product\'s category is not an integer" do
    get "/categories/inProduct/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("PRO_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("product")
  end

  it "retrieves a department\'s list of categories" do
    first_category_department = first_category.department
    first_category_department_id = first_category.department_id
    department_categories = first_category_department.categories

    get "/categories/inDepartment/#{first_category.department_id}"
    expect(response).to be_successful
    expect(json.size).to eq(department_categories.size)
    expect(json[0]["department_id"]).to eq(first_category.department_id)
    expect(json[1]["department_id"]).to eq(first_category.department_id) if json[1]

  end

  it "returns appropriate error message if the department ID params passed to get a department\'s list of categories is not found" do
    departments = Department.all
    last_department_id = departments.last.id
    department_not_found = last_department_id + 1

    get "/categories/inDepartment/#{department_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("DEP_02")
    expect(error["message"]).to eq("Don't exist department with this ID.")
    expect(error["field"]).to eq("department")
  end

  it "returns appropriate error message if the ID params passed to get a department\'s list of categories is not an integer" do
    get "/categories/inDepartment/d"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(422)
    expect(error).to be_truthy
    expect(error["status"]).to eq(422)
    expect(error["code"]).to eq("DEP_01")
    expect(error["message"]).to eq("The ID is not a number.")
    expect(error["field"]).to eq("department")
  end
end