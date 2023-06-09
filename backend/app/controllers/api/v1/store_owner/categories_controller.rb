module Api
  module V1
    module StoreOwner
      class CategoriesController < Base
        before_action :authenticate_store_owner!

        def index
          @categories = Category.all

          render json: @categories.as_json, status: :ok
        end

        def create
          @category = Category.new category_params
          if
            @category.save!
            render json: @category.as_json, status: :ok
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        private

        def category_params
          params.permit(:name)
        end
      end
    end
  end
end
