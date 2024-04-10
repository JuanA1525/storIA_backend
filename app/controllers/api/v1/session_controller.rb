class Api::V1::SessionController < ApplicationController
    
    skip_before_action :authenticate_request, only: [:create]
    
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
end 