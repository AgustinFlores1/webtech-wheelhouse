class ServiceCatalogsController < ApplicationController
  def index
    @service_catalogs_list = ServiceCatalog.list_by_name
  end

  def show
    @service_catalog = ServiceCatalog.find(params[:id])
  end
end
