require "rails_helper"

RSpec.describe "Task", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  before do
    signin(user.email, user.password)
  end

  describe "#index" do
    it "lists tasks" do
      task
      visit tasks_path
      expect(page).to have_text("Task List")
    end
  end
end
