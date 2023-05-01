module Api
  module V1
    module Customers
      class CustomersController < Base
        before_action :authenticate_customer!

        def me
          render json: @current_customer.as_json(
            except: :id,
          ), status: :ok
        end

        def update
          if @current_customer.update(customer_params)
            render json: @current_customer.as_json(
              except: :id,
            ), status: :ok
          else
            render json: { error: @current_customer.errors }, status: :bad_request
          end
        end

        # def delete
        #   @current_customer.destroy!
        #   head :ok
        # rescue StandardError => e
        #   render json: { errors: e.message }, status: :bad_request
        # end

        private

        def customer_params
          params.permit(:name, :email, :password, :password_confirmation, :address, :contact, :gender)
        end

        def find_customer
          @customer = Customer.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
