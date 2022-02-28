class InterviewsController < ApplicationController
    #before_action :admin_authorize_request
    
    def initialize
        @firestore = DbOperations.new
    end

    def create
       @firestore.add_interview(params)
       render json: { message: 'Interview added successfully' }, status: :created
    end

    def update
        
    end
    
end
