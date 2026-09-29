class ServiceCatalogsController < ApplicationController
  before_action :set_service_catalog, only: %i[show edit update destroy]

  def index
    @service_catalogs_list = ServiceCatalog.list_by_name
  end

  def show
  end

  def new
    @service_catalog = ServiceCatalog.new
  end

  def edit
  end

  def create
    @service_catalog = ServiceCatalog.new(service_catalog_params)
    if @service_catalog.save
      redirect_to @service_catalog, notice: "The service \"#{@service_catalog.name}\" has been successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service_catalog.update(service_catalog_params)
      redirect_to @service_catalog, notice: "The service \"#{@service_catalog.name}\" has been successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service_catalog.destroy
      redirect_to service_catalogs_path, status: :see_other, notice: "Service #{@service_catalog.name} successfully deleted"
    else
      redirect_to @service_catalog, alert: @service_catalog.errors.full_messages.to_sentence
    end
  end

  private

  def set_service_catalog
    @service_catalog = ServiceCatalog.find(params[:id])
  end

  def service_catalog_params
    params.expect(service_catalog: [ :name, :is_active, :current_price ])
  end
end
