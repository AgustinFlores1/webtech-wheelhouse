# app/policies/repair_policy.rb
class RepairPolicy < ApplicationPolicy
  MECHANIC_ATTRIBUTES = [ :status, :diagnosis, { intake_photos: [] } ].freeze
  DESK_ATTRIBUTES = [
  :bike_id, :customer_id, :assigned_mechanic_id, :reported_issue,
  :promised_return_on, :estimated_price, :closed_at,
  { repair_services_attributes: [ [ :id, :service_catalog_id, :agreed_price, :_destroy ] ] }
  ].freeze

  def index?
    true
  end

  def show?
    user.owner? || user.counter? || assigned_to_user?
  end

  def create?
    user.owner? || user.counter?
  end

  def update?
    return true if user.owner?
    return false if record.closed?

    user.counter? || assigned_to_user?
  end

  def destroy?
    user.owner?
  end

  def permitted_attributes
    if user.owner? || user.counter?
      MECHANIC_ATTRIBUTES + DESK_ATTRIBUTES
    elsif user.mechanic?
      MECHANIC_ATTRIBUTES
    else
      []
    end
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.owner? || user.counter?
        scope.all
      elsif user.mechanic? && user.staff_member_id.present?
        scope.where(assigned_mechanic_id: user.staff_member_id)
      else
        scope.none
      end
    end
  end

  def remove_intake_photo?
    return true if user.owner?
    return false if record.closed?

    user.counter?
  end

  private

  def assigned_to_user?
    user.mechanic? &&
    user.staff_member_id.present? &&
    record.assigned_mechanic_id == user.staff_member_id
  end
end
