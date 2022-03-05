require 'securerandom'
require "google/cloud/firestore"
class DbOperations
    def initialize
      @firestore = Google::Cloud::Firestore.new(
        project_id: "interview-management-portal",
        credentials: "app/assets/db/keyfile.json"
      )
    end

    def add_user(user)
      data = { password: user[:password], is_admin: user[:is_admin], designation: user[:designation]}
      users_ref = @firestore.col 'users'
      users_ref.doc("#{user[:email]}").set(data)
    end

    def find_user(user_id)
      user = nil
      users = get_users
      for current_user in users do
        if current_user[:email] == user_id
          user = current_user
        end
      end
      user
    end

    def get_users
        users = @firestore.col "users"
        users_array = []
        users.get do |user|
            tmp_record = {email: user.document_id, password: user['password'], is_admin: user['is_admin']}
            users_array.push(tmp_record)
        end
        users_array
    end

    def add_interview(interview)
      id = SecureRandom.uuid
      data = { candidate_name: interview[:candidate_name], stack: interview[:stack], interviewers: interview[:interviewers]}
      interviews_ref = @firestore.col 'interviews'
      interviews_ref.doc("#{id}").set(data)
    end
    
end