module Api
  class Base < ActionController::API
    include Pagy::Backend
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
    protected

    def render_unprocessable_entity_response error, status: :unprocessable_entity
      render json: Errors::ActiveRecordValidation.new(error.record).to_hash, status: status
    end

    def render_record_not_found_response error, status: :not_found

      render json: Errors::ActiveRecordNotFound.new(
        error).to_hash, status: status
    end

    def authenticate_employee!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      employee_id = JsonWebToken.decode(token)["employee_id"] if token
      @current_employee = Employee.find_by id: employee_id
      @current_branch = @current_employee&.branch
      return if @current_employee && @current_employee.employee?

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end

    def authenticate_manager!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      employee_id = JsonWebToken.decode(token)["employee_id"] if token
      @current_manager = Employee.find_by id: employee_id
      return if @current_manager && @current_manager.manager?

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end

    def authenticate_store_owner!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      employee_id = JsonWebToken.decode(token)["employee_id"] if token
      @current_store_owner = Employee.find_by id: employee_id
      @current_branch = @current_store_owner&.branch
      return if @current_store_owner && @current_store_owner.store_owner?

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end

    def authenticate_customer!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      customer_id = JsonWebToken.decode(token)["customer_id"] if token
      @current_customer = Customer.find_by id: customer_id
      return if @current_customer

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end

    def authenticate_admin!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      admin_id = JsonWebToken.decode(token)["admin_id"] if token
      @current_admin = Admin.find_by id: admin_id
      return if @current_admin

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end
  end
end
