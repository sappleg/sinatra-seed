require 'routes/route'

module Ottoman
    class Errors < Route
        Route.error 401 do
            settings.authentication_failure.to_json
        end

        Route.error 404 do
            body.data.to_json
        end

        Route.error 500 do
            status 500
            body.data.to_json
        end
    end
end
