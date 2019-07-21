require "rails_helper"

RSpec.describe OrderDetailsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/order_details").to route_to("order_details#index")
    end

    it "routes to #show" do
      expect(:get => "/order_details/1").to route_to("order_details#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/order_details").to route_to("order_details#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/order_details/1").to route_to("order_details#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/order_details/1").to route_to("order_details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/order_details/1").to route_to("order_details#destroy", :id => "1")
    end
  end
end
