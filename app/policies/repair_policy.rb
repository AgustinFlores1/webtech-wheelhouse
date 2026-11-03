# app/policies/repair_policy.rb
class RepairPolicy < ApplicationPolicy
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
