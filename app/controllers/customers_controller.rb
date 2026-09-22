class CustomersController < ApplicationController
  def index
    @customers_list = Customer.list_by_name
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
