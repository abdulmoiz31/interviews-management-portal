class AuthenticationController < ApplicationController
    before_action :admin_authorize_request, except: [:login, :change_password]
    before_action :authorize_request, only: [:change_password]

    def initialize
        @firestore = DbOperations.new
    end

    # POST /auth/login
    def login
      @user = @firestore.find_user(params[:email])
      if @user
        if authenticate(@user, params[:password])
            token = JsonWebToken.encode(user_id: @user[:email])
            render json: { token: token, email: @user[:email],is_admin: @user[:is_admin] }, status: :ok
          else
            render json: { error: 'Incorrect Password' }, status: :unauthorized
          end
      else
        render json: { error: 'Incorrect email' }, status: :unauthorized
      end
    end

    def signup
        user = @firestore.find_user(params[:email])
        if user == nil
            @firestore.add_user(params)
            render json: { message: 'User added successfully' }, status: :created
        else
          render json: { error: 'Email already registered' }, status: :bad_request
        end
        
    end

    def change_password
        if @@current_user[:password] == params[:old_password]
            @@current_user[:password] = params[:new_password]
            @firestore.add_user(@@current_user)
            render json: { message: 'Password changed successfully' }, status: :ok  
        else
            render json: { error: 'Incorrect old password' }, status: :bad_request
        end
    end

    private

    def authenticate(user, password)
        authenticated = false
        if user[:password] == password
            authenticated = true
        end
        authenticated
    end

    def login_params
      params.permit(:email, :password)
    end
end
