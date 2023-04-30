Employee.create!(
  name: "Manager User",
  email: "pharmacymanager@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Ha Noi Viet Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "manager",
)

Branch.create!(
  name: "Hồ Chí Minh",
  address: "Hồ Chí Minh - Việt Nam",
  branch_code: "HCM",
  email: "hochiminhbranch@gmail.com",
  contact: Faker::PhoneNumber.unique.phone_number
)

Branch.create!(
  name: "Đà Nẵng",
  address: "Đà Nẵng - Việt Nam",
  branch_code: "DN",
  email: "danangbranch@gmail.com",
  contact: Faker::PhoneNumber.unique.phone_number
)

Branch.create!(
  name: "Hà Nội",
  address: "Hà Nội - Việt Nam",
  branch_code: "HN",
  email: "hanoibranch@gmail.com",
  contact: Faker::PhoneNumber.unique.phone_number
)

20.times do |n|
  name = Faker::Name.unique.name
  email = "employeetest-#{n+1}@gmail.com"
  password = "123456"
  address = "Ha Noi Viet Nam",
  contact = Faker::PhoneNumber.unique.phone_number

  Employee.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    role: "employee",
    address: address,
    contact: contact,
    branch_id: Branch.all.pluck(:id).sample
  )
end

20.times do |n|
  name = Faker::Name.unique.name
  email = "storeownertest-#{n+1}@gmail.com"
  password = "123456"
  address = "Ha Noi Viet Nam",
  contact = Faker::PhoneNumber.unique.phone_number

  Employee.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    role: "store_owner",
    address: address,
    contact: contact,
    branch_id: Branch.all.pluck(:id).sample
  )
end

20.times do |n|
  name = Faker::Name.unique.name
  email = "customertest-#{n+1}@gmail.com"
  password = "123456"
  address = "Ha Noi Viet Nam",
  contact = Faker::PhoneNumber.unique.phone_number

  Customer.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    address: address,
    contact: contact,
  )
end

5.times do
  name = Faker::Book.unique.genre
  Category.create! name:name
end

10.times do |n|
  name = Faker::Name.unique.name
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address
  email = "suppliertest-#{n+1}@gmail.com"
  Supplier.create!(
    name: name,
    contact: phone_num,
    address: address,
    email: email,
  )
end

10.times do |n|
  name = Faker::Name.unique.name
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address
  email = "suppliertest-#{n+1}@gmail.com"
  Supplier.create!(
    name: name,
    contact: phone_num,
    address: address,
    email: email,
  )
end

10.times do |n|
  batch_code = Faker::Code.nric
  expired_date = Faker::Date.between(from: 60.days.ago, to: Date.today)

  BatchInventory.create!(
    batch_code: batch_code,
    expired_date: expired_date
  )
end

50.times do
  name = Faker::Book.unique.title
  price = Faker::Commerce.price(range: 1..100)
  inventory_type = ["pill", "blister_packs", "pill_pack", "pill_bottle"].sample
  quantity = Faker::Number.between(from: 50, to: 100)
  inventory_code = Faker::Code.nric
  main_ingredient = Faker::IndustrySegments.sector
  producer = Faker::Nation.nationality
  # image = Faker::Avatar.image
  Inventory.create!(
              name: name,
              price: price,
              #  image: image,
               inventory_type: inventory_type,
               inventory_code: inventory_code,
               quantity: quantity,
               main_ingredient: main_ingredient,
               producer: producer,
               category_id: Category.all.pluck(:id).sample,
               batch_inventory_id: BatchInventory.all.pluck(:id).sample,
               supplier_id: Supplier.all.pluck(:id).sample,
               branch_id: Branch.all.pluck(:id).sample,
               created_at: (rand*30).days.ago
  )
end

50.times do
  price = Faker::Commerce.price(range: 1..100)
  quantity = Faker::Number.between(from: 50, to: 100)
  import_inventory_code = Faker::Code.nric
  branch_id = Branch.all.pluck(:id).sample
  employee_id = Employee.where(branch_id: branch_id).pluck(:id).sample
  ImportInventory.create!(
              price: price,
              import_inventory_code: import_inventory_code,
              quantity: quantity,
              batch_inventory_id: BatchInventory.all.pluck(:id).sample,
              supplier_id: Supplier.all.pluck(:id).sample,
              branch_id: branch_id,
              inventory_id: Inventory.all.pluck(:id).sample,
              created_at: (rand*30).days.ago,
              employee_id: employee_id
  )
end

50.times do
  total_price = Faker::Commerce.price(range: 1..100)
  total_quantity = Faker::Number.between(from: 10, to: 50)
  order_code = Faker::Code.nric
  branch_id = Branch.all.pluck(:id).sample
  employee_id = Employee.where(branch_id: branch_id).pluck(:id).sample
  customer_id = Customer.pluck(:id).sample
  Order.create!(
    total_price: total_price,
    order_code: order_code,
    total_quantity: total_quantity,
    branch_id: branch_id,
    inventory_id: Inventory.all.pluck(:id).sample,
    created_at: (rand*30).days.ago,
    employee_id: employee_id
  )
end
