module Api
  class Base < ActionController::API
    before_filter :cors_preflight_check

    include Pagy::Backend
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
    protected

    def cors_preflight_check
      if request.method == :options
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end
    end

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

    def authenticate_admin!
      token = request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
      employee_id = JsonWebToken.decode(token)["employee_id"] if token
      @current_admin = Employee.find_by id: employee_id
      return if @current_admin && @current_admin.admin?

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end
  end
end
