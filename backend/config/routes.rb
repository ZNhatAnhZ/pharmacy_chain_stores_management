Rails.application.routes.draw do
  scope module: "api", path: "api" do
    scope module: "v1", path: "v1" do
      post "/login", to: "auth#create"
      post 'password/forgot', to: 'password#forgot'
      post 'password/reset', to: 'password#reset'
      put 'password/update', to: 'password#update'

      scope module: "manager", path: "manager" do
        resources :admins
        resources :branches
        resources :employees
        resources :categories
        resources :suppliers
        resources :inventories do
          get :get_expired, on: :collection
          get :get_out_of_stock, on: :collection
          get :send_request_mail_to_supplier, on: :collection
        end
        resources :statistic do
          get :get_total_order_price, on: :collection
          get :get_order_count, on: :collection
          get :get_revenue_order, on: :collection
          get :get_total_import_inventory_price, on: :collection
          get :get_order_by_branch, on: :collection
          get :header_statistic, on: :collection
          get :get_import_inventory_count, on: :collection
          get :get_revenue_import_inventory, on: :collection
        end
        resources :ledger
        resources :import_inventories
        resources :orders
        resources :export_csv do
          get :export_employee, on: :collection
          get :export_inventory, on: :collection
          get :export_order, on: :collection
          get :export_import_inventory, on: :collection
          get :export_ledger, on: :collection
        end
        resources :batch_inventories do
          get :get_all_expired, on: :collection
        end
      end

      scope module: "store_owner", path: "store_owner" do
        resources :branches
        resources :employees
        resources :categories
        resources :suppliers
        resources :batch_inventories do
          get :get_all_expired, on: :collection
        end
        resources :inventories do
          get :get_expired, on: :collection
          get :get_out_of_stock, on: :collection
          get :send_request_mail_to_supplier, on: :collection
          delete :destroy_all_expired, on: :collection
        end
        resources :ledger
        resources :import_inventories
        resources :orders do
          put :complete_order, on: :member
        end
        resources :export_csv do
          get :export_employee, on: :collection
          get :export_inventory, on: :collection
          get :export_order, on: :collection
          get :export_import_inventory, on: :collection
          get :export_ledger, on: :collection
        end
        resources :statistic do
          get :get_total_order_price, on: :collection
          get :get_order_count, on: :collection
          get :get_revenue_order, on: :collection
          get :get_import_inventory_count, on: :collection
          get :get_revenue_import_inventory, on: :collection
          get :get_total_import_inventory_price, on: :collection
          get :header_statistic, on: :collection
        end
      end

      scope module: "employ", path: "employ" do
        resources :batch_inventories do
          get :get_all_expired, on: :collection
        end
        resources :inventories do
          get :get_expired, on: :collection
          get :get_out_of_stock, on: :collection
          get :send_request_mail_to_supplier, on: :collection
          delete :destroy_all_expired, on: :collection
        end
        resources :export_csv do
          get :export_employee, on: :collection
          get :export_inventory, on: :collection
          get :export_order, on: :collection
          get :export_import_inventory, on: :collection
          get :export_ledger, on: :collection
        end
        resources :statistic do
          get :get_total_order_price, on: :collection
          get :get_order_count, on: :collection
          get :get_revenue_order, on: :collection
          get :get_import_inventory_count, on: :collection
          get :get_revenue_import_inventory, on: :collection
          get :get_total_import_inventory_price, on: :collection
          get :header_statistic, on: :collection
        end
        resources :import_inventories
        resources :orders do
          put :complete_order, on: :member
        end
        resources :employees
      end

      scope module: "customers", path: "customers" do
      post "/login", to: "customer_auth#create"
        resources :orders

        resources :inventories do
          get :get_expired, on: :collection
          get :get_out_of_stock, on: :collection
        end
      end
    end
  end

end
