module ExceptionHandler

    extend ActiveSupport::Concern

    included do
        rescue_from Exception, with: :internal_server_error
        rescue_from ActiveRecord::RecordNotFound, with: :validation_not_found_error
        rescue_from ActiveRecord::RecordInvalid, with: :validation_error
        rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

        private

        def render_error_json(message = ' ', status)
            render json: { error: {message: message} }, status: status 
        end

        def internal_server_error(e)
            Rails.logger.error e.message
            render_error_json e.message, :internal_server_error
        end

        def validation_error(e)
            Rails.logger.error e.message
            render_error_json e.message, :bad_request
        end

        def validation_not_found_error(e)
            render_error_json "The record doesn't exist in the database", :not_found
        end

        def user_not_authorized(e)
            render_error_json "User not authorized to do this action", :forbidden
        end
        
    end
end