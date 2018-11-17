require 'rails_helper'

RSpec.describe Task do
  let(:user) { create(:user) }

  it "creates a new instance given valid attributes" do
    create(:task)
    expect(Task.count).to eq(1)
  end

  it "requires a description" do
    task_with_no_description = build(:task, description: nil)
    expect(task_with_no_description).to_not be_valid
  end

  describe "positioning" do
    it "sets the position to the top" do
      task1 = create(:task, user: user)
      expect(task1.position).to eq 1
      task2 = create(:task, user: user)
      expect(task2.reload.position).to eq 1
      expect(task1.reload.position).to eq 2
    end

    it "scopes the position to the user" do
      task1 = create(:task)
      task2 = create(:task)
      expect(task1.reload.position).to eq 1
      expect(task2.reload.position).to eq 1
    end

    it "prevents updates from exceeding the max position" do
      task1 = create(:task, user: user)
      task2 = create(:task, user: user, position: 5)
      expect(task1.reload.position).to eq 1
      expect(task2.reload.position).to eq 2
    end

    it "allows updates to position 0 to be sent to the top of the list (position 1)" do
      task1 = create(:task, user: user)
      task2 = create(:task, user: user, position: 0)
      expect(task1.reload.position).to eq 2
      expect(task2.reload.position).to eq 1
    end
  end

  describe "attachments" do
    it "can be attached" do
      task = create(:task, :with_attachment)
      expect(task.attachments.attached?).to be true
    end

    it "can be deleted" do
      task = create(:task, :with_attachment)
      expect(task.attachments.attached?).to be true
      task.attachments.purge
      expect(task.attachments.attached?).to be false
    end
  end
end
