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
      # An inactive service is not on the wall, so here it answers 404 like a missing one.
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

      # The document of a service. The one place its shape is written: index, show and
      # (requirement 4) create all call it, so a client parses one shape.
      # is_active, created_at and updated_at are columns, but nobody reading the wall needs them.
      def service_document(service)
        {
          id: service.id,
          name: service.name,
          # A decimal column arrives as a BigDecimal, and Rails writes a BigDecimal into JSON as
          # a string ("20.0"). Converted here so the price travels as a number (docs/api.md).
          price: service.current_price.to_f,
          # Not a column: on how many repairs this service was charged. repair_services was
          # preloaded by includes, so this reads memory, not the database once per service.
          # uniq: the repair form does not stop the same service on two lines of one repair,
          # and that is still one repair.
          times_charged: service.repair_services.map(&:repair_id).uniq.size
        }
      end
    end
  end
end