require 'rails_helper'

RSpec.describe CreateAccountUserForm do
  let(:valid_params) do
    {
      main_role: "admin",
      email: "test@example.com",
      status: "active",
      password: "password123",
      password_confirmation: "password123",
      user_profile_attributes: {
        full_name: "John Doe",
        phone: "0901234567",
        avatar_url: "avatar.png",
        locale: "en",
        time_zone: "Asia/Ho_Chi_Minh"
      }
    }
  end

  it "is valid with correct params" do
    form = CreateAccountUserForm.new(valid_params)
    expect(form).to be_valid
  end

  it "is invalid when email missing" do
    valid_params[:email] = nil

    expect {
      CreateAccountUserForm.new(valid_params)
    }.to raise_error(ActiveModel::ValidationError)
  end

  it "is invalid when password does not match" do
    valid_params[:password_confirmation] = "wrongpass"

    expect {
      CreateAccountUserForm.new(valid_params)
    }.to raise_error(ActiveModel::ValidationError)
  end

  it "is invalid when locale is unsupported" do
    valid_params[:user_profile_attributes][:locale] = "zz"

    expect {
      CreateAccountUserForm.new(valid_params)
    }.to raise_error(ActiveModel::ValidationError)
  end
end
