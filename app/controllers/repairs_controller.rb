class RepairsController < ApplicationController
  before_action :set_repair, only: %i[show edit update destroy]
  before_action :load_form_options, only: %i[new edit create update]

  def index
    @repairs_list = Repair.includes(:bike, :customer, :assigned_mechanic).list_by_promised_return_on
  end

  def show
  end

  def new
    bike = Bike.find_by(id: params[:bike_id])
    @repair = Repair.new(bike: bike, customer: bike&.customer)
    fill_blank_lines
  end

  def create
    @repair = Repair.new(repair_params)
    if @repair.save
      redirect_to @repair, notice: "The repair #{@repair.id} has been successfully created"
    else
      fill_blank_lines
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @repair.update(repair_params)
      redirect_to @repair, notice: "The repair #{@repair.id} has been successfully updated"
    else
      fill_blank_lines
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path, status: :see_other, notice: "Repair #{@repair.id} successfully deleted"
    else
      redirect_to @repair, alert: @repair.errors.full_messages.to_sentence
    end
  end

  def edit
    fill_blank_lines
  end

  private

  def set_repair
    @repair = Repair.includes(:bike, :customer, :assigned_mechanic,
                              repair_services: :service_catalog).find(params[:id])
  end

  def load_form_options
    @bikes     = Bike.list_by_serial
    @customers = Customer.list_by_name
    @mechanics = StaffMember.mechanics.list_by_name
    @services  = ServiceCatalog.list_by_name
  end

  def fill_blank_lines
    existing = @repair.repair_services.size
    target = @repair.persisted? ? existing + 2 : 3
    (target - existing).times { @repair.repair_services.build }
  end

  def repair_params
    params.expect(
      repair: [
        :bike_id, :customer_id, :assigned_mechanic_id, :status,
        :reported_issue, :promised_return_on, :estimated_price, :closed_at,
        { repair_services_attributes: [ [ :id, :service_catalog_id, :agreed_price, :_destroy ] ] }
      ]
    )
  end
end
