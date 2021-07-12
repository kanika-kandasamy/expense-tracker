class ApplicationController < ActionController::API
    include Pundit
    def json_payload
        HashWithIndifferentAccess.new(JSON.parse(request.raw_post))
    end

    private

    def current_user
        current_user = Current.user
    end
end
