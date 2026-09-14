class CustomersController < ApplicationController
  def index
    @customers_list = Customer.order(:name)
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
