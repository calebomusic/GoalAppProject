require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_presence_of(:session_token) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should allow_value("password", nil).for(:password) }
  end

  describe "associations" do
    it { should have_many(:goals) }
  end

  describe "::find_by_credentials" do
    subject!(:billybob) do
      FactoryGirl.create(:user)
    end

    it "should find a user from the database" do
      expect(User.find_by_credentials('BillyBob', 'password')).to eq(billybob)
    end

    it "should return nil for user with invalid credentials" do
      expect(User.find_by_credentials('BillyBob', 'schpassword')).to be_nil
    end
  end
end
