module Api
  module V1
    module Employ
      class EmployeesController < Base
        before_action :authenticate_employee!, except: %i(create)
        before_action :find_employee, except: %i(create index)
        before_action :correct_employee, only: %i(update show)

        def show
          render json: @current_employee.as_json(
            except: :id,
            include: { branch: { except: %i[id] } }
          ), status: :ok
        end

        def update
          if @current_employee.authenticate(params[:current_password])
            if @current_employee.update(employee_params)
              render json: @current_employee.as_json, status: :ok
            else
              render json: { error: @current_employee.errors }, status: :bad_request
            end
          else
            render json: { error: "Current password is incorrect" }, status: :bad_request
          end
        end
        private

        def employee_params
          params.permit(:name, :email, :password, :password_confirmation, :address, :contact, :gender)
        end

        def find_employee
          @employee = Employee.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        def correct_employee
          return if @current_employee == @employee

          render json: {
            message: ["Not correct employee"],
            status: 400,
            type: "Fail"
          }, status: :bad_request
        end
      end
    end
  end
end
