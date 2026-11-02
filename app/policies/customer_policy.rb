# app/policies/customer_policy.rb
class CustomerPolicy < ApplicationPolicy
  def index?
    user.owner? || user.counter?
  end

  def show?
    user.owner? || user.counter?
  end

  def create?
    user.owner? || user.counter?
  end

  def update?
    user.owner? || user.counter?
  end

  def destroy?
    user.owner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.owner? || user.counter?
        scope.all
      else
        scope.none
      end
    end
  end
end
