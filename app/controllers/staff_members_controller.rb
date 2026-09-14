class StaffMembersController < ApplicationController
  def index
    @staff_list = StaffMember.order(:role)
  end

  def show
    @staff_member = StaffMember.find(params[:id])
  end
end
