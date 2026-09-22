class BikesController < ApplicationController
  def index
    @bikes_list = Bike.list_by_customer
  end

  def show
    @bike = Bike.find(params[:id])
  end
end
