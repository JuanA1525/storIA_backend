class ApplicationController < ActionController::API
    include JsonWebToken
    before_action :authenticate_request

    private
        def authenticate_request
            header = request.headers['Authorization']
            header = header.split(' ').last if header
            decoded = jwt_decode(header)
            puts "-----> Decoded in ApplicationController: #{decoded.inspect}"
            puts "-----> decioded[:user_id]: #{decoded[:user_id]}"
            @current_user = User.find_by(id: decoded[:user_id])
            puts "-----> @current_user: #{@current_user.inspect}"
        end
end
