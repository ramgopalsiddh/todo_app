require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'example@example.com',
        password: 'password123'
      )
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = User.new(password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is not valid without a password" do
      user = User.new(email: 'example@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "is not valid with a duplicate email" do
      User.create(email: 'existing@example.com', password: 'password123')
      user = User.new(email: 'existing@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end
  end
end
