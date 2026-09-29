class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: %i[show edit update destroy]

  def index
    @staff_members_list = StaffMember.list_by_role
  end

  def show
  end

  def new
    @staff_member = StaffMember.new
  end

  def edit
  end

  def create
    @staff_member = StaffMember.new(staff_member_params)
    if @staff_member.save
      redirect_to @staff_member, notice: "The staff member \"#{@staff_member.name} - #{@staff_member.role}\" has been successfully created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @staff_member.update(staff_member_params)
      redirect_to @staff_member, notice: "The staff member \"#{@staff_member.name} - #{@staff_member.role}\" has been successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @staff_member.destroy
      redirect_to staff_members_path, status: :see_other, notice: "Staff member #{@staff_member.name} successfully deleted"
    else
      redirect_to @staff_member, alert: @staff_member.errors.full_messages.to_sentence
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end

  def staff_member_params
    params.expect(staff_member: [ :name, :role ])
  end
end
