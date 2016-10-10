require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe "validations" do
    # debugger
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:private) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:user_id) }
  end

  describe "association" do
    it { should belong_to(:user) }
  end
end
