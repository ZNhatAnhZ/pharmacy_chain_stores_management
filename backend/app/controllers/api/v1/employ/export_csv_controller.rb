require "csv"

module Api
  module V1
    module Employ
      class ExportCsvController < Base
        def export_employee
          @employees = Employee.all
          header = ["Tên", "Email", "Chi nhánh"]

          result = CSV.generate do |csv|
            csv << header
            @employees.each do |employee|
              csv << [employee.name, employee.email, employee&.branch&.name]
            end
          end

          send_data(result, filename: "employees.csv", type: "text/csv", disposition: 'attachment')
        end

        def export_inventory
          @inventories = Inventory.search_by_branch(params["branch_id"])
          header = ["Tên", "Mã thuốc", "Số lượng", "Giá", "Đơn vị", "Thành phần chính", "Nơi sản xuất", "Thể loại", "Lô sản phẩm", "Nhà cung cấp", "Chi nhánh"]

          result = CSV.generate do |csv|
            csv << header
            @inventories.each do |inventory|
              csv << [inventory.name, inventory.inventory_code, inventory.quantity, inventory.price, inventory.inventory_type,
                        inventory.main_ingredient, inventory.producer, inventory&.category&.name, inventory&.batch_inventory&.batch_code, inventory&.supplier&.name, inventory&.branch&.name]
            end
          end

          send_data(result, filename: "inventories.csv", type: "text/csv", disposition: 'attachment')
        end

        def export_order
          @orders = Order.search_by_branch(params["branch_id"])
          header = ["Mã đơn bán", "Mã thuốc", "Tên thuốc", "Đơn giá", "Số lượng", "Tên khách hàng", "Tên nhân viên", "Chi nhánh"]

          result = CSV.generate do |csv|
            csv << header
            @orders.each do |order|
              csv << [order.order_code, order&.inventory&.inventory_code, order&.inventory&.name, order.total_price, order.total_quantity,
                        order&.customer&.name, order&.employee&.name, order&.branch&.name]
            end
          end

          send_data(result, filename: "orders.csv", type: "text/csv", disposition: 'attachment')
        end

        def export_import_inventory
          @import_inventories = ImportInventory.search_by_branch(params["branch_id"])
          header = ["Mã đơn nhập", "Mã thuốc", "Tên thuốc", "Đơn giá", "Số lượng", "Mã lô", "Ngày hết hạn lô", "Tên nhà cung cấp", "Tên nhân viên", "Chi nhánh"]

          result = CSV.generate do |csv|
            csv << header
            @import_inventories.each do |im|
              csv << [im.import_inventory_code, im&.inventory&.inventory_code, im&.inventory&.name, im.price, im.quantity,
                        im&.batch_inventory&.batch_code, im&.batch_inventory&.expired_date, im&.supplier&.name, im&.employee&.name, im&.branch&.name]
            end
          end

          send_data(result, filename: "import_inventories.csv", type: "text/csv", disposition: 'attachment')
        end

        def export_ledger
          @orders = Order.search_by_branch(params["branch_id"])
          @import_inventories = ImportInventory.search_by_branch(params["branch_id"])

          arr_order = @orders.map {|order|
            order.as_json(only: %i[created_at]).merge(
              {revenue: order.total_price * order.total_quantity, code: order&.order_code, type: "order"}
            )
          }

          arr_import_inventory = @import_inventories.map {|import_inventory|
            import_inventory.as_json(only: %i[created_at]).merge(
              {revenue: import_inventory.price * import_inventory.quantity, code: import_inventory&.import_inventory_code, type: "import_inventory"}
            )
          }

          @arr_result = arr_order + arr_import_inventory

          header = ["Mã giao dịch", "Ngày tạo", "Loại giao dịch", "Tổng tiền"]
          result = CSV.generate do |csv|
            csv << header
            @arr_result.each do |record|
              csv << [record[:code], record[:created_date], record[:type], record[:revenue]]
            end
          end

          send_data(result, filename: "ledger.csv", type: "text/csv", disposition: 'attachment')
        end
      end
    end
  end
end
