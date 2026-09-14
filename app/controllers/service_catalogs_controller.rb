class ServiceCatalogsController < ApplicationController
  def index
    @services_list = ServiceCatalog.order(:name)
  end

  def show
    @service = ServiceCatalog.find(params[:id])
  end
end
