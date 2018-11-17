require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks" do
    let(:task) { create(:task) }

    context "when sender is signed in" do
      before do
        sign_in task.user
        get "/tasks"
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "should have HTML content" do
        expect(response.content_type).to eq "text/html"
      end

      it "has the task in the response body" do
        expect(response.body).to include "task_id=#{task.id}"
      end
    end

    context "when sender is not signed in" do
      before do
        get "/tasks"
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when multiple users have tasks" do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }
      let(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: other_user) }

      before do
        sign_in user
        task
        other_task
        get "/tasks"
      end

      it "returns only tasks that belong to that user" do
        expect(response.body).to include "task_id=#{task.id}"
        expect(response.body).to_not include "task_id=#{other_task.id}"
      end
    end
  end
end
