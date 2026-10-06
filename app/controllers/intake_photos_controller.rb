class IntakePhotosController < ApplicationController
  before_action :set_repair
  before_action :set_intake_photo

  def destroy
    filename = @intake_photo.filename
    @intake_photo.purge
    redirect_to @repair, status: :see_other,
                notice: "Photo #{filename} was removed from repair ##{@repair.id}"
  end

  private

  def set_repair
    @repair = Repair.find(params[:repair_id])
  end

  def set_intake_photo
    @intake_photo = @repair.intake_photos.find(params[:id])
  end
end