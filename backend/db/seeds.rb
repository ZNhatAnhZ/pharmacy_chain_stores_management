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

Admin.create!(
  name: "Quản trị viên",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
)

Employee.create!(
  name: "Quản lý hệ thống",
  email: "pharmacymanager@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Hà Nội - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "manager",
)

Employee.create!(
  name: "Nguyễn Việt Đức",
  email: "hanoi.storeowner@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Hà Nội - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "store_owner",
  branch_id: 0
)

Employee.create!(
  name: "Nguyễn Viết Thái",
  email: "danang.store_owner@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Đà Nẵng - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "store_owner",
  branch_id: 1
)

Employee.create!(
  name: "Hoàng Thanh Lâm",
  email: "hochiminh.store_owner@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Hồ Chí Minh - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "store_owner",
  branch_id: 2
)

Employee.create!(
  name: "Nguyễn Trần Nhật Anh",
  email: "nguyen.nhat.anh@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Hồ Chí Minh - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "employee",
  branch_id: 2
)

Employee.create!(
  name: "Nguyễn Tiến Đàn",
  email: "nguyen.tien.dan@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "Hồ Chí Minh - Việt Nam",
  contact: Faker::PhoneNumber.unique.phone_number,
  role: "employee",
  branch_id: 2
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
    gender: ["male", "female"].sample,
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
    gender: ["male", "female"].sample
  )
end

10.times do |n|
  name = ["Thuốc kháng dị ứng", "Thuốc thần kinh", "Thuốc xương khớp", "Vitamin", "Giảm đau, hạ sốt", "Thuốc da liễu", "Thuốc tiêu hóa", "Thuốc cảm lạnh", "Thuốc kháng viêm", "Thuốc khác"]
  Category.create! name:name[n]
end

10.times do |n|
  name = Faker::Company.unique.name
  phone_num = Faker::PhoneNumber.unique.phone_number
  address = Faker::Address.full_address,
  email = Faker::Internet.email(name: name),
  Supplier.create!(
    name: name,
    contact: phone_num,
    address: address,
    email: email,
  )
end

10.times do |n|
  batch_code = Faker::Code.nric
  expired_date = Faker::Date.between(from: 30.days.ago, to: 90.days.after)

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
  inventory_id = Inventory.all.pluck(:id).sample
  supplier_id = Inventory.find(inventory_id).supplier_id
  batch_inventory_id = Inventory.find(inventory_id).batch_inventory_id
  branch_id = Branch.all.pluck(:id).sample
  employee_id = Employee.where(branch_id: branch_id).pluck(:id).sample
  ImportInventory.create!(
              price: price,
              import_inventory_code: import_inventory_code,
              quantity: quantity,
              batch_inventory_id: batch_inventory_id,
              supplier_id: supplier_id,
              branch_id: branch_id,
              inventory_id: inventory_id,
              created_at: (rand*60).days.ago,
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
  status = ["complete", "pending", "canceled", "rejected"].sample
  Order.create!(
    total_price: total_price,
    order_code: order_code,
    total_quantity: total_quantity,
    branch_id: branch_id,
    inventory_id: Inventory.all.pluck(:id).sample,
    created_at: (rand*60).days.ago,
    employee_id: employee_id,
    customer_id: customer_id,
    status: status
  )
end
