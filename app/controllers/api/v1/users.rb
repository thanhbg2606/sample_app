module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      prefix "api"
      version "v1", using: :path
      format :json

      before do
        authenticate_user!
      end

      resource :users do
        desc "Return all users"
        get "", root: :users do
          users = User.all
          present users, with: API::Entities::User
        end

        desc "Return a user"
        params do
          requires :id, type: String, desc: "ID of the user"
        end
        get ":id", root: "user" do
          user = User.find params[:id]
          present user, with: API::Entities::User
        end
      end
    end
  end
end
