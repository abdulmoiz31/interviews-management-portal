class ApplicationController < ActionController::API
    
    def initialize
        @firestore = DbOperations.new
    end

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @@current_user = @firestore.find_user(@decoded[:user_id])
          if @@current_user == nil
             raise 'Invalid token' 
          end
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        rescue => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end

    def admin_authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @@current_user = @firestore.find_user(@decoded[:user_id])
          if @@current_user == nil
             raise 'Invalid token' 
          end
          if !@@current_user[:is_admin]
              raise 'User does not has admin rights'
          end
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        rescue => e
            render json: { errors: e.message }, status: :unauthorized
        end
    end
end
