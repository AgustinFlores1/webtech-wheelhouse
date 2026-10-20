module Api
  module V1
    # The wall list of the shop: public, and only the active services.
    class ServicesController < BaseController
      before_action :authenticate, only: :create
      # GET /api/v1/services
      def index
        services = ServiceCatalog.active.includes(:repair_services).list_by_name
        render json: services.map { |service| service_document(service) }
      end

      # GET /api/v1/services/:id
      def show
        service = ServiceCatalog.active.includes(:repair_services).find(params[:id])
        render json: service_document(service)
      end

      def create
        service = ServiceCatalog.new(service_params)
        if service.save
          render json: service_document(service), status: :created, location: api_v1_service_url(service)
        else
          render_errors(service.errors.full_messages, :unprocessable_content)
        end
      end

      private

      def service_params
        attributes = params.expect(service: [ :name, :price ])
        { name: attributes[:name], current_price: attributes[:price] }
      end

      # The document of a service.
      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: service.current_price.to_f,
          times_charged: service.repair_services.map(&:repair_id).uniq.size
        }
      end
    end
  end
end