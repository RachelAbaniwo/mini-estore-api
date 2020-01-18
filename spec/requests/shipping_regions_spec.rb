require 'rails_helper'

RSpec.describe "ShippingRegions", type: :request do
  describe "GET /shipping_regions" do
    it "works! (now write some real specs)" do
      get shipping_regions_path
      expect(response).to have_http_status(200)
    end
  end
end
