class RepairsController < ApplicationController
  def index
    @repairs_list = Repair.includes(:bike, :customer, :assigned_mechanic).list_by_promised_return_on
  end

  def show
    @repair = Repair.includes(:bike, :customer, :assigned_mechanic, repair_services: :service_catalog).find(params[:id])
  end
end
