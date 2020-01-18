require 'rails_helper'

describe "Departments API", :type => :request do

  departments = Department.all
  department_count = departments.count
  first_department = departments.first
  first_department_id = first_department.id

  it "retrieves all departments" do
    get departments_path
    expect(json.size).to eq(department_count)
    expect(response).to be_successful
  end

  it "retrieves a specific department" do
    get "/departments/#{first_department_id}"
    expect(response).to be_successful
    expect(json["name"]).to eq(first_department.name)
    expect(json["description"]).to eq(first_department.description)
  end

  it "returns appropriate error message if the ID params passed to get a specific department is not found" do
    last_department_id = departments.last.id
    department_not_found = last_department_id + 1

    get "/departments/#{department_not_found}"
    error = json["error"]
    expect(response).not_to be_successful
    expect(status).to eq(404)
    expect(error).to be_truthy
    expect(error["status"]).to eq(404)
    expect(error["code"]).to eq("DEP_02")
    expect(error["message"]).to eq("Don't exist department with this ID.")
    expect(error["field"]).to eq("department")
  end

  it "returns appropriate error message if the ID params passed to get a specific department is not an integer" do
    get "/departments/d"
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
