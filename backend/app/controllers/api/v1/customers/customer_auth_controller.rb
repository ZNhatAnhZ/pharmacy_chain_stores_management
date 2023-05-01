module Api
  module V1
    module Customers
      class CustomerAuthController < Base
        def create
          customer = Customer.find_by email: params[:email]
          if customer&.authenticate params[:password]
            generate_token customer
            render json: {access_token: @data[:access_token], customer_id: customer&.id,
              customer_name: customer&.name, customer_email: customer&.email, customer_address: customer&.address, customer_contact: customer&.contact, customer_gender: customer&.gender}, status: :ok
          else
            render json: {message: "Invalid email or password combination", success: false}, status: :unauthorized
          end
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
