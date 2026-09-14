class BikesController < ApplicationController
  def index
    @bikes_list = Bike.order(:customer_id)
  end

  def show
    @bike = Bike.find(params[:id])
  end
end
