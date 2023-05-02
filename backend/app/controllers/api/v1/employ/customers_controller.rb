module Api
  module V1
    module Employ
      class CustomersController < Base
        before_action :authenticate_employee!
        before_action :find_customer, only: :show

        def show
          render json: @customer.as_json(), status: :ok
        end

        def index
          render json: Customer.all.as_json(), status: :ok
        end

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
