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

  #context "when user clicks chat from account", js: true do
    #before do
      #message
      #visit my_reviews_path
      #within("#review-#{review.id}") do
        #find(:css, '.menuBars').click
      #end
      #click_on('Chat')
    #end

    #it "displays the chat message" do
      #expect(page).to have_text("MyMessage")
    #end
  #end
end
