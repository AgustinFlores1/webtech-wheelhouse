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

      # The value of ?state=, checked against the enum. Repair.statuses is the hash the enum
      # declaration built, so no state name is written here, and a new state needs no change.
      def requested_state
        state = params[:state]
        return state if Repair.statuses.key?(state)

        raise ActionController::BadRequest,
              "\"#{state}\" is not a state. The states are: #{Repair.statuses.keys.join(", ")}"
      end

      # The document of a repair. Every key is a decision; nothing in it is a foreign key.
      # Left out on purpose (see docs/api.md): the customer's phone, the mechanic, the reported
      # issue, the diagnosis, the photos and the estimated price. Accounting needs what was
      # charged and when, not how the repair was done.
      def repair_document(repair)
        {
          id: repair.id,
          state: repair.status,
          came_in_on: repair.created_at.to_date,
          promised_on: repair.promised_return_on,
          handed_back_on: repair.closed_at&.to_date,
          customer_answer: repair.customer_answer,
          bike: bike_document(repair.bike),
          # The customer of the repair, not the bike's current owner: a bike can change owners
          # (user story 10), and the repair belongs to whoever brought it in.
          customer: { name: repair.customer.name },
          lines: repair.repair_services.map do |line|
            { service: line.service_catalog.name, price: line.agreed_price.to_f }
          end,
          # Repair#total adds the agreed prices as BigDecimal, exactly, on the server.
          # Only the result becomes a number, so no client has to add floats.
          total: repair.total.to_f,
          overdue: repair.overdue?
        }
      end

      # The shop stores brand and model in one column (make_model, "Trek Marlin 5").
      # The first word is the brand and the rest is the model: true for every bike of the shop,
      # and written down in docs/api.md as the rule, with its limit (a two-word brand).
      def bike_document(bike)
        brand, model = bike.make_model.split(" ", 2)
        { brand: brand, model: model, serial_number: bike.serial_number }
      end
    end
  end
end