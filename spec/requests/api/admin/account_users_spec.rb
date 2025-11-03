require 'rails_helper'

RSpec.describe "Admin::AccountUsers API", type: :request do
  describe "POST /api/admin/account_users" do
    let(:params) do
      {
        main_role: "admin",
        email: "test@example.com",
        status: "active",
        password: "password123",
        password_confirmation: "password123",
        user_profile_attributes: {
          full_name: "John Doe",
          phone: "0901234567",
          avatar_url: "my-image.png",
          locale: "en",
          time_zone: "Asia/Ho_Chi_Minh"
        }
      }
    end

    before do
      # Mock S3 upload service
      allow(S3UploadService).to receive(:upload)
                                  .and_return("https://s3.com/account_users/avatar.png")
    end

    it "creates account user successfully" do
      post "/api/admin/account_users", params: params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)

      expect(json["message"]).to eq("Create account user successfully")
      expect(json["data"]["account_user"]["email"]).to eq("test@example.com")

      # S3 upload must be called
      expect(S3UploadService).to have_received(:upload).once
    end

    it "returns validation error when missing email" do
      params[:email] = nil

      post "/api/admin/account_users", params: params

      expect(response.status).to eq(400) # or your custom error code
      json = JSON.parse(response.body)

      expect(json["error"]).to eq("Validation failed")
      expect(json["details"]["email"]).to include("Email is required")
    end
  end
end
