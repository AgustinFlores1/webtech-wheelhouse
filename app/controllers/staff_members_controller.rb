class StaffMembersController < ApplicationController
  def index
    @staff_members_list = StaffMember.list_by_role
  end

  def show
    @staff_member = StaffMember.find(params[:id])
  end
end
