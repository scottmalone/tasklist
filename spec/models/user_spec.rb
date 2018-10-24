require 'rails_helper'

RSpec.describe User do
  it "creates a new instance given valid attributes" do
    user = create(:user)
    expect(User.count).to eq(1)
  end

  it "requires an email address" do
    no_email_user = build(:user, email: nil)
    expect(no_email_user).to_not be_valid
  end

  describe "password" do
    it "cannot be blank" do
      no_password = build(:user, password: '', password_confirmation: '')
      expect(no_password).to_not be_valid
    end

    it "must contain at least one letter and one non-letter." do
      valid_password = build(:user, password: 'password101', password_confirmation: 'password101')
      expect(valid_password).to be_valid
    end

    it "and cannot have less than 8 characters." do
      password_with_incorrect = build(:user, password: 'pass1', password_confirmation: 'pass1')
      expect(password_with_incorrect).to_not be_valid
    end
  end
end
