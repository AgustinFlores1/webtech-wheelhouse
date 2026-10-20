module Api
  module V1
    # The repairs, for the shop's accounting program. Private: every action needs the token.
    class RepairsController < BaseController
      before_action :authenticate

      # GET /api/v1/repairs
      # GET /api/v1/repairs?state=closed
      def index
        repairs = Repair.includes(:customer, :bike, repair_services: :service_catalog).list_by_created_at
        repairs = repairs.where(status: requested_state) if params.key?(:state)

        render json: repairs.map { |repair| repair_document(repair) }
      end

      # GET /api/v1/repairs/:id
      def show
        repair = Repair.includes(:customer, :bike, repair_services: :service_catalog).find(params[:id])
        render json: repair_document(repair)
      end

      private

      # The value of ?state=, checked against the enum.
      def requested_state
        state = params[:state]
        return state if Repair.statuses.key?(state)

        raise ActionController::BadRequest,
              "\"#{state}\" is not a state. The states are: #{Repair.statuses.keys.join(", ")}"
      end

      # The document of a repair.
      def repair_document(repair)
        {
          id: repair.id,
          state: repair.status,
          came_in_on: repair.created_at.to_date,
          promised_on: repair.promised_return_on,
          handed_back_on: repair.closed_at&.to_date,
          customer_answer: repair.customer_answer,
          bike: bike_document(repair.bike),
          customer: { name: repair.customer.name },
          lines: repair.repair_services.map do |line|
            { service: line.service_catalog.name, price: line.agreed_price.to_f }
          end,
          total: repair.total.to_f,
          overdue: repair.overdue?
        }
      end

      # The document of a bike.
      def bike_document(bike)
        brand, model = bike.make_model.split(" ", 2)
        { brand: brand, model: model, serial_number: bike.serial_number }
      end
    end
  end
end