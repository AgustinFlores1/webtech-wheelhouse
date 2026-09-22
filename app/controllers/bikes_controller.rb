class BikesController < ApplicationController
  def index
    @bikes_list = Bike.includes(:customer).list_by_customer
  end

  def show
    @bike = Bike.includes(:customer, repairs: [:customer, :assigned_mechanic]).find(params[:id])
  end
end
