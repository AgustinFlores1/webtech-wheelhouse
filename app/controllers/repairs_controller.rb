class RepairsController < ApplicationController
  def index
    @repairs_list = Repair.list_by_promised_return_on
  end

  def show
    @repair = Repair.find(params[:id])
  end
end
