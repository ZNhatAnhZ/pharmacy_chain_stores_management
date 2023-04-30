module Api
  module V1
    module Manager
      class EmployeesController < Base
        before_action :authenticate_manager!
        before_action :find_employee, except: %i(create index)

        def index
          @employees = Employee.employee.search_by_branch(params["branch_id"])
          render json: @employees.as_json, status: :ok
        end

        def show
          render json: @employee.as_json(
            include: { branch: { except: %i[id] } }
          ), status: :ok
        end

        def update
          return render json: { error: "Not permission" }, status: :bad_request if @employee.manager? && @employee != @current_manager

          if @current_manager == @employee
            if @current_manager.authenticate(params[:current_password])
              if @current_manager.update(employee_params)
                render json: @current_manager.as_json, status: :ok
              else
                render json: { error: @current_manager.errors }, status: :bad_request
              end
            else
              render json: { error: "Current password is incorrect" }, status: :bad_request
            end
          else
            if @employee.update(employee_params)
              render json: @employee.as_json, status: :ok
            else
              render json: { error: @employee.errors }, status: :bad_request
            end
          end
        end

        def destroy
          @employee.destroy!
          head :ok
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
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
          params.permit(:name, :email, :password, :password_confirmation, :branch_id, :role, :address, :contact, :gender)
        end

        def find_employee
          @employee = Employee.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
