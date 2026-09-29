class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  def index
    @customers_list = Customer.list_by_name
  end

  def show
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer, notice: "The customer #{@customer.name} has been succesfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "The customer #{@customer.name} has been succesfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.destroy
      redirect_to customers_path, status: :see_other, notice: "Customer #{@customer.name} succesfully deleted"
    else
      redirect_to @customer, alert: @customer.errors.full_messages.to_sentence
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.expect(customer: [ :name, :phone ])
  end
end
