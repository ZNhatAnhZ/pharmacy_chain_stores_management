module Api
  module V1
    module Customers
      class InventoriesController < Base
        before_action :authenticate_customer!
        before_action :find_inventory, only: %i(show update destroy)

        def index
          @inventories = Inventory.search_by_branch(params["branch_id"]).search_by_name(params["search_name"]).sort_price(params["sort_price"]).sort_created_time(params["created_time"])
          @inventories = @inventories.most_ordered if params["most_ordered"].present?

          render json: @inventories.map {|inventory|
            if inventory.image.attached?
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
            else
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
            end
          }, status: :ok
        end

        def show
          if @inventory.image.attached?
            render json: @inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(@inventory.image)}), status: :ok
          else
            render json: @inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]), status: :ok
          end
        end

        def get_expired
          day_left = params[:day_left].present? ? params[:day_left].to_i : 0
          batch_expired = BatchInventory.get_expired(day_left).pluck :id

          @expired_inventories = Inventory.search_by_branch(params["branch_id"]).where(batch_inventory_id: batch_expired)
          render json: @expired_inventories.map {|inventory|
            if inventory.image.attached?
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
            else
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
            end
          }, status: :ok
        end

        def get_out_of_stock
          quantity_left = params[:quantity_left].present? ? params[:quantity_left].to_i : 0
          @out_of_stock_inventories = Inventory.search_by_branch(params["branch_id"]).get_out_of_stock(quantity_left)

          render json: @out_of_stock_inventories.map {|inventory|
            if inventory.image.attached?
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
            else
              inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
            end
          }, status: :ok
        end

        private

        def inventory_params
          params.permit(:name, :price, :inventory_type, :quantity, :category_id, :batch_inventory_id,
                        :supplier_id, :image, :main_ingredient, :producer, :inventory_code)
        end

        def find_inventory
          @inventory = Inventory.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
