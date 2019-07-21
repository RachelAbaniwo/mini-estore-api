require "rails_helper"

RSpec.describe ShippingRegionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/shipping_regions").to route_to("shipping_regions#index")
    end

    it "routes to #show" do
      expect(:get => "/shipping_regions/1").to route_to("shipping_regions#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/shipping_regions").to route_to("shipping_regions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shipping_regions/1").to route_to("shipping_regions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shipping_regions/1").to route_to("shipping_regions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shipping_regions/1").to route_to("shipping_regions#destroy", :id => "1")
    end
  end
end
