module Api
  module V1
    module Customers
        class OrdersController < Base
        before_action :authenticate_customer!
        before_action :find_order, except: %i(create index)
        before_action :check_quantity, only: %i(create)

        def index
          @orders = @current_customer.order.time_between(params[:start_date]&.to_time, params[:end_date]&.to_time)
          render json: @orders.as_json(
            include: {
              inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
              branch: { except: %i[created_at updated_at] },
              employee: { except: %i[created_at updated_at] },
              customer: { except: %i[created_at updated_at] }
            }
          ), status: :ok
        end

        def create
          branch_id = Inventory.find_by(id: params[:inventory_id]).branch_id
          @order = Order.new order_params.merge(order_code: generate_order_code, branch_id: branch_id, customer_id: @current_customer.id, status: "pending")
          if @order.save!
            render json: @order.as_json(
              include: {
                inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
                branch: { except: %i[created_at updated_at] },
                employee: { except: %i[created_at updated_at] },
                customer: { except: %i[created_at updated_at] }
              }
            ), status: :ok
          end
        rescue StandardError => e
          render json: {error: e.message}, status: :bad_request
        end

        def show
          render json: @order.as_json(
            include: {
              inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
              branch: { except: %i[created_at updated_at] },
              employee: { except: %i[created_at updated_at] },
              customer: { except: %i[created_at updated_at] }
            }
          ), status: :ok
        end

        def canceled_order
          return render json: {message: "already canceled order"}, status: :ok if @order.canceled?

          if @order.update status: "canceled"
            render json: @order.as_json, status: :ok
          else
            render json: { error: @order.errors }, status: :bad_request
          end
        end

        def update
          if !@order.complete?
            if @order.update(order_params)
              render json: @order.as_json, status: :ok
            else
              render json: { error: @order.errors }, status: :bad_request
            end
          else
            render json: { error: "Can not update completed order" }, status: :bad_request
          end
        end

        def destroy
          if !@order.complete?
            @order.destroy!
            head :ok
          else
            render json: { error: "Can not delete completed order" }, status: :bad_request
          end
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        private

        def order_params
          params.permit(:total_price, :total_quantity, :status, :inventory_id, :employee_id, :customer_id)
        end

        def find_order
          @order = Order.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        def check_quantity
          @inventory = Inventory.find_by! id: params[:inventory_id]
          if @inventory.quantity < params[:total_quantity].to_i
            render json: {error: "order quantity large than inventory quantity"}, status: :bad_request
            return
          end
        end

        def generate_order_code
          "ORDER_CODE_" + Time.now.strftime('%Y%m%d%H%M%S')
        end
      end
    end
  end
end
