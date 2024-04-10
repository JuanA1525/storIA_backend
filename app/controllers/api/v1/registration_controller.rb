class Api::V1::RegistrationController < ApplicationController
    
    include JsonWebToken
    skip_before_action :authenticate_request, only: [:create]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
    
        if @user.save
            token = jwt_encode(user_id: @user.id)
            render json: { token: token }, status: :ok
        else
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    def user_params
        params.require(:user).permit(:name, :last_name, :mail, :birth_date, :password, :password_confirmation)
    end

end