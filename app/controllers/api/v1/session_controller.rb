class Api::V1::SessionController < ApplicationController
    
    skip_before_action :authenticate_request, only: [:create, :global_numbers]
    
    def destroy
        session[:user_id] = nil
        render json: { message: "Logged Out" }, status: :created
    end

    def create
        @user = User.find_by(mail: params[:mail])
        if @user.present? && @user.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { token: token }, status: :ok
        else
            render json: { errors: "Invalid email or password" }, status: :unauthorized
        end
    end

    def global_numbers
        render json: 
        {
            num_stories: 12500000,
            num_users: 142384,
            num_characters: 598000
        }
    end

    def current_user_info
        if @current_user
          render json: @current_user, status: :ok
        else
          render json: { error: 'No current user' }, status: :not_found
        end
      end
end 