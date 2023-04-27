module Api
  module V1
    class EmployeesController < Base
      before_action :authenticate_employee!, except: %i(create)
      before_action :find_employee, except: %i(create index)
      before_action :correct_employee, only: %i(update)
      before_action :admin_employee, only: %i(destroy)

      def show
        render json: @current_employee.as_json(
          except: :id,
          include: { branch: { except: %i[id] } }
        ), status: :ok
      end

      def create
        @employee = Employee.new employee_params
        if
          @employee.save!
          render json: @employee.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def employee_params
        params.permit()
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

      def admin_employee
        return if @current_employee.admin?

        render json: {
          message: ["Not admin"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end
    end
  end
end
