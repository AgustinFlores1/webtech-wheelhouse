# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Customer.delete_all

customers_data = [
  { name: "Scott Cawthon",   phone: "+56 9 5521 3348" },
  { name: "Jhon Skyrim",     phone: "+56 9 6634 1120" },
  { name: "Arthur Morgan",   phone: "+56 9 4423 9981" },
  { name: "Sadie Adler",     phone: "+56 9 8812 2247" },
  { name: "Charles Smith",   phone: "+56 9 3390 6612" },
  { name: "Jhon Marston",    phone: "+56 9 7715 8834" },
  { name: "Riebeck Wilds",   phone: "+56 9 2298 4471" },
  { name: "Verso Dessandre", phone: "+56 9 6601 3392" },
  { name: "Kyle Crane",      phone: "+56 9 5583 7726" },
  { name: "Aiden Caldwell",  phone: "+56 9 4459 2210" }
]
customers = customers_data.map { |attrs| Customer.create!(attrs) }
customer_by_name = customers.index_by(&:name)

ServiceCatalog.delete_all

services_data = [
  { name: "Flat Tire Repair",         current_price: 20 },
  { name: "Brake Adjustment",         current_price: 30 },
  { name: "Chain Replacement",        current_price: 25 },
  { name: "Gear Adjustment",          current_price: 30 },
  { name: "Wheel Truing",             current_price: 40 },
  { name: "Hydraulic Brake Bleed",    current_price: 50 },
  { name: "Full Tune-Up",             current_price: 100 },
  { name: "Bottom Bracket Service",   current_price: 45 },
  { name: "Drivetrain Cleaning",      current_price: 35 },
  { name: "Spoke Replacement",        current_price: 15 },
  { name: "Headset Adjustment",       current_price: 25 },
  { name: "Cable & Housing Install",  current_price: 30 },
  { name: "Tire Replacement",         current_price: 28 },
  { name: "Tube Replacement",         current_price: 12 },
  { name: "Pedal Replacement",        current_price: 18 },
  { name: "Saddle Adjustment",        current_price: 10 },
  { name: "Handlebar Tape Wrap",      current_price: 20 },
  { name: "Fork Service",             current_price: 60 },
  { name: "Rear Derailleur Adjustment", current_price: 22 },
  { name: "Full Bike Wash & Lube",    current_price: 15 },
  { name: "Kickstand Installation",   current_price: 10 },
  { name: "Basket/Rack Installation", current_price: 18 }
]

services = services_data.map { |attrs| ServiceCatalog.create!(attrs) }
services_by_name = services.index_by(&:name)

StaffMember.delete_all

staff_data = [
  { name: "Jeremy Falls",     role: "shop_owner" },
  { name: "Samantha Winters", role: "counter_clerk" },
  { name: "Carlos Springs",   role: "mechanic" },
  { name: "Roberto Autumn",   role: "mechanic" },
  { name: "Alkahul Cawera",   role: "mechanic"}
]

staff = staff_data.map { |attrs| StaffMember.create!(attrs) }

Bike.delete_all

bikes_data = [
  { serial_number: "TRK-8827-A", make_model: "Trek Marlin 5",         colour: "Blue",   owner: "Scott Cawthon" },
  { serial_number: "GNT-1140-C", make_model: "Giant Escape 3",        colour: "Black",  owner: "Jhon Skyrim" },
  { serial_number: "TRK-9931-B", make_model: "Trek Marlin 5",         colour: "Blue",   owner: "Arthur Morgan" }, # same make/model/colour as first, different serial
  { serial_number: "SPC-2214-D", make_model: "Specialized Sirrus",    colour: "Red",    owner: "Sadie Adler" },
  { serial_number: "GNT-5567-E", make_model: "Giant Talon 3",         colour: "Green",  owner: "Scott Cawthon" }, # Scott's second bike
  { serial_number: "CAN-3321-F", make_model: "Cannondale Quick 4",    colour: "Silver", owner: "Charles Smith" },
  { serial_number: "TRK-6650-G", make_model: "Trek FX 2",             colour: "Orange", owner: "Jhon Marston" },
  { serial_number: "SCT-4482-H", make_model: "Scott Sub Cross 40",    colour: "White",  owner: "Riebeck Wilds" },
  { serial_number: "GNT-7793-I", make_model: "Giant Escape 3",        colour: "Black",  owner: "Verso Dessandre" },
  { serial_number: "SPC-1128-J", make_model: "Specialized Rockhopper", colour: "Grey",  owner: "Kyle Crane" },
  { serial_number: "CAN-8865-K", make_model: "Cannondale Trail 5",    colour: "Blue",   owner: "Aiden Caldwell" },
  { serial_number: "TRK-2247-L", make_model: "Trek Domane AL 2",      colour: "Red",    owner: "Charles Smith" } # Charles's second bike
]

bikes = bikes_data.map do |b|
  Bike.create!(
    serial_number: b[:serial_number],
    make_model: b[:make_model],
    colour: b[:colour],
    customer_id: customer_by_name.fetch(b[:owner]).id
  )
end

bikes_by_serial = bikes.index_by(&:serial_number)

Repair.delete_all

mechanics = staff.select { |s| s.role == "mechanic" }
carlos, roberto, alkahul = mechanics[0], mechanics[1], mechanics[2]

repairs_data = [
  # 1. Fresh arrival, nothing known yet — no estimate, no mechanic
  { bike: "TRK-8827-A", status: "arrived",
    created_at: Time.current, promised_return_on: 4.days.from_now.to_date },

  # 2. Same bike as #1, but an already-closed repair — "one bike, more than one repair, different dates"
  { bike: "TRK-8827-A", status: "closed",
    created_at: 20.days.ago, promised_return_on: 17.days.ago.to_date,
    estimated_price: 30, assigned_mechanic: carlos, closed_at: 16.days.ago },

  # 3. Quoted, waiting on the customer's answer
  { bike: "GNT-1140-C", status: "pending_approval",
    created_at: 2.days.ago, promised_return_on: 5.days.from_now.to_date,
    estimated_price: 45 },

  # 4. Approved, but no mechanic has picked it up yet
  { bike: "TRK-9931-B", status: "approved",
    created_at: 1.day.ago, promised_return_on: 4.days.from_now.to_date,
    estimated_price: 60 },

  # 5. "Customer heard the price and said no"
  { bike: "SPC-2214-D", status: "declined",
    created_at: 3.days.ago, promised_return_on: 2.days.from_now.to_date,
    estimated_price: 80 },

  # 6. A mechanic is actively working on it right now
  { bike: "GNT-5567-E", status: "in_progress",
    created_at: 5.days.ago, promised_return_on: 1.day.from_now.to_date,
    estimated_price: 55, assigned_mechanic: roberto },

  # 7. Work is done, just sitting on the rack waiting for pickup
  { bike: "CAN-3321-F", status: "completed",
    created_at: 6.days.ago, promised_return_on: 1.day.ago.to_date,
    estimated_price: 40, assigned_mechanic: alkahul },

  # 8. An ordinary closed repair
  { bike: "TRK-6650-G", status: "closed",
    created_at: 25.days.ago, promised_return_on: 22.days.ago.to_date,
    estimated_price: 35, assigned_mechanic: carlos, closed_at: 21.days.ago },

  # 9. OVERDUE - still not handed back
  { bike: "SCT-4482-H", status: "in_progress",
    created_at: 10.days.ago, promised_return_on: 3.days.ago.to_date,
    estimated_price: 90, assigned_mechanic: roberto },

  # 10. In and out today, (no estimated_price)
  { bike: "GNT-7793-I", status: "closed",
    created_at: Time.current.beginning_of_day + 9.hours,
    promised_return_on: Date.current,
    assigned_mechanic: alkahul,
    closed_at: Time.current.beginning_of_day + 14.hours },

  # 11. Another one currently waiting on approval,
  { bike: "CAN-8865-K", status: "pending_approval",
    created_at: Time.current, promised_return_on: 6.days.from_now.to_date,
    estimated_price: 50 },

  # 12. OLD repair, prices on the list have since changed
  { bike: "TRK-2247-L", status: "closed",
    created_at: 14.months.ago, promised_return_on: 14.months.ago.to_date + 3.days,
    estimated_price: 38, assigned_mechanic: carlos, closed_at: 14.months.ago + 2.days },

  # 13. A second, older, closed repair on Jhon Skyrim's bike
  { bike: "GNT-1140-C", status: "closed",
    created_at: 40.days.ago, promised_return_on: 37.days.ago.to_date,
    estimated_price: 25, assigned_mechanic: roberto, closed_at: 38.days.ago },

  # 14. Sadie's bike back again with a second, brand-new issue
  { bike: "SPC-2214-D", status: "arrived",
    created_at: Time.current, promised_return_on: 3.days.from_now.to_date },

  # 15. One more approved-but-unassigned
  { bike: "TRK-6650-G", status: "approved",
    created_at: 1.day.ago, promised_return_on: 5.days.from_now.to_date,
    estimated_price: 42 }
]

repairs = repairs_data.map do |r|
  bike = bikes_by_serial.fetch(r[:bike])
  Repair.create!(
    bike_id: bike.id,
    customer_id: bike.customer_id,
    status: r[:status],
    reported_issue: "Reported issue for bike #{r[:bike]}: needs inspection and repair.",
    estimated_price: r[:estimated_price],
    promised_return_on: r[:promised_return_on],
    assigned_mechanic_id: r[:assigned_mechanic]&.id,
    created_at: r[:created_at],
    closed_at: r[:closed_at]
  )
end

RepairService.delete_all

repair_services_data = [
  # All the ones that are arrived, pending aproval or denied dont have the agreed price and are not being repaired

  # Old closed repair, single service, full price
  { repair: repairs[1], service: "Brake Adjustment", agreed_price: services_by_name.fetch("Brake Adjustment").current_price },

  # Approved, awaiting a mechanic; services already selected, one discounted
  { repair: repairs[3], service: "Wheel Truing",       agreed_price: services_by_name.fetch("Wheel Truing").current_price },
  { repair: repairs[3], service: "Spoke Replacement",  agreed_price: 12 }, # list is 15 — regular customer discount

  # In progress, two services, one discounted
  { repair: repairs[5], service: "Chain Replacement", agreed_price: 20 }, # list is 25
  { repair: repairs[5], service: "Gear Adjustment",   agreed_price: services_by_name.fetch("Gear Adjustment").current_price },

  # Completed, sitting ready for pickup
  { repair: repairs[6], service: "Full Tune-Up", agreed_price: services_by_name.fetch("Full Tune-Up").current_price },

  # Ordinary closed repair
  { repair: repairs[7], service: "Flat Tire Repair", agreed_price: services_by_name.fetch("Flat Tire Repair").current_price },

  # OVERDUE, in progress, three services
  { repair: repairs[8], service: "Hydraulic Brake Bleed",  agreed_price: services_by_name.fetch("Hydraulic Brake Bleed").current_price },
  { repair: repairs[8], service: "Bottom Bracket Service", agreed_price: services_by_name.fetch("Bottom Bracket Service").current_price },
  { repair: repairs[8], service: "Headset Adjustment",     agreed_price: services_by_name.fetch("Headset Adjustment").current_price },

  # Same-day flat tyre, in and out
  { repair: repairs[9], service: "Flat Tire Repair", agreed_price: services_by_name.fetch("Flat Tire Repair").current_price },

  # From 14 months ago; today's Full Tune-Up is $100, this was charged at last year's rate
  { repair: repairs[11], service: "Full Tune-Up", agreed_price: 85 },

  # Old closed repair, three services, one discounted
  { repair: repairs[12], service: "Wheel Truing",           agreed_price: services_by_name.fetch("Wheel Truing").current_price },
  { repair: repairs[12], service: "Brake Adjustment",       agreed_price: services_by_name.fetch("Brake Adjustment").current_price },
  { repair: repairs[12], service: "Cable & Housing Install", agreed_price: 25 } # list is 30
]

repair_services_data.each do |rs|
  RepairService.create!(
    repair_id: rs[:repair].id,
    service_catalog_id: services_by_name.fetch(rs[:service]).id,
    agreed_price: rs[:agreed_price]
  )
end
