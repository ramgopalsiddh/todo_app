require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it 'is valid with valid attributes' do
      user = User.create!(email: 'ramgopal@gmail.com', password: 'ramgopal')
      task = Task.new(
        title: 'Valid Title',
        description: 'Valid Description',
        due_date: Date.new(2024, 5, 31),
        user: user
      )
      expect(task).to be_valid
    end

    it "is not valid without a title" do
      task = Task.new(
        description: "Valid Description",
        due_date: Date.today + 1.day
      )
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "is not valid without a description" do
      task = Task.new(
        title: "Valid Title",
        due_date: Date.today + 1.day
      )
      expect(task).not_to be_valid
      expect(task.errors[:description]).to include("can't be blank")
    end

    it "is not valid without a due date" do
      task = Task.new(
        title: "Valid Title",
        description: "Valid Description"
      )
      expect(task).not_to be_valid
      expect(task.errors[:due_date]).to include("can't be blank")
    end

    it "is not valid without a user" do
      task = Task.new(
        title: "Valid Title",
        description: "Valid Description",
        due_date: Date.today + 1.day
      )
      expect(task).not_to be_valid
      expect(task.errors[:user]).to include("must exist")
    end
  end
end
