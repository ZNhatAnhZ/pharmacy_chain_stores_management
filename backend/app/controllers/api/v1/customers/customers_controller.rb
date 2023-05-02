module Api
  module V1
    module Customers
      class CustomersController < Base
        before_action :authenticate_customer!, except: :create

        def create
          customer = Customer.new(customer_params)
          if
            customer.save!
            generate_token customer
            render json: {access_token: @data[:access_token], customer_id: customer&.id,
              customer_name: customer&.name, customer_email: customer&.email, customer_address: customer&.address, customer_contact: customer&.contact, customer_gender: customer&.gender}, status: :ok
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        def me
          render json: @current_customer.as_json(), status: :ok
        end

        def update
          if @current_customer.authenticate(params[:current_password])
            if @current_customer.update(customer_params)
              render json: @current_customer.as_json(), status: :ok
            else
              render json: { error: @current_customer.errors }, status: :bad_request
            end
          else
            render json: { error: "Current password is incorrect" }, status: :bad_request
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

        def generate_token customer

          access_token = JsonWebToken.encode(customer_id: customer.id)
          @data = {
            access_token: access_token,
            token_type: "Bearer"
          }
        end
      end
    end
  end
end
