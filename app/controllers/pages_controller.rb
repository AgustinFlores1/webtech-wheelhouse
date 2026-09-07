class PagesController < ApplicationController
  def home
    @message = "We offer a wide range of bicycles, accessories,
    and repair services to keep you riding smoothly.Whether you're a
    casual rider or a seasoned cyclist, we have something for everyone."
  end

  def services
    @services = ServiceCatalog.where(is_active: true).order(:name)
  end

  def workshop
    @hours = {
      weekdays: "9 AM - 5 PM",
      weekends: "10 AM - 4 PM"
    }
    @location = "123 CapyBara, BikeCity"
  end

  def about
    @members = [
      { name: "Jermey", role: "Owner and Lead Mechanic" },
      { name: "Samantha", role: "Customer Service" },
      { name: "Carlos", role: "Senior Mechanic" },
      { name: "Roberto", role: "Junior Mechanic" }
    ]

    @contact_number = sprintf("+56 9 %04d %04d", rand(0..9999), rand(0..9999))
  end
end
