class BikesController < ApplicationController
  before_action :set_bike, only: %i[show edit update destroy]
  before_action :load_customers, only: %i[new edit create update]

  def index
    @bikes_list = Bike.includes(:customer).list_by_customer
  end

  def show
  end

  def new
    @bike = Bike.new(customer_id: params[:customer_id])
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)
    if @bike.save
      redirect_to @bike, notice: "The bike #{@bike.serial_number} has been successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike, notice: "The bike #{@bike.serial_number} has been successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @bike.destroy
      redirect_to bikes_path, status: :see_other, notice: "Bike #{@bike.serial_number} successfully deleted"
    else
      redirect_to @bike, alert: @bike.errors.full_messages.to_sentence
    end
  end

  private

  def load_customers
    @customers = Customer.list_by_name
  end

  def set_bike
    @bike = Bike.includes(:customer, repairs: [ :customer, :assigned_mechanic ]).find(params[:id])
  end

  def bike_params
    params.expect(bike: [ :colour, :make_model, :serial_number, :customer_id ])
  end
end
