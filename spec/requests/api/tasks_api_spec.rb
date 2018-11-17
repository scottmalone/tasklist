require 'rails_helper'

RSpec.describe "Tasks API", type: :request do
  describe "POST /api/tasks" do
    let(:user) { create(:user) }
    let(:post_params) do
      {
        task: {
          description: "Booyah",
          due: Time.now
        }
      }
    end

    context "when sender is signed in" do
      before do
        sign_in user
        frozen_time = Time.local(2020, 11, 3, 0, 0, 0)
        Timecop.freeze(frozen_time)
        post "/api/tasks", params: post_params
      end

      after do
        Timecop.return
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "responds with json by default" do
        expect(response.content_type).to eq "application/vnd.api+json"
      end

      it "creates one record" do
        expect(Task.count).to eq 1
      end

      it "has the POSTed attributes in the response body" do
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(resp_attrs["description"]).to eq post_params[:task][:description]
        expect(resp_attrs["due"].to_datetime).to eq post_params[:task][:due].to_datetime
      end
    end

    context "when sender is not signed in" do
      before do
        post "/api/tasks", params: post_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PUT /api/tasks/:id" do
    let(:task) { create(:task) }
    let(:put_params) do
      {
        task: {
          description: "Updated message",
          due: Time.local(2024, 11, 5, 0, 0, 0),
          completed: true
        }
      }
    end

    context "when sender is signed in" do
      before do
        sign_in task.user
        frozen_time = Time.local(2020, 11, 3, 0, 0, 0)
        Timecop.freeze(frozen_time)
        put "/api/tasks/#{task.id}", params: put_params
      end

      after do
        Timecop.return
      end

      it "responds with json by default" do
        expect(response.content_type).to eq "application/vnd.api+json"
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "the response body has the POSTed attributes" do
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(resp_attrs["description"]).to eq put_params[:task][:description]
        expect(resp_attrs["due"].to_datetime).to eq put_params[:task][:due].to_datetime
      end

      it "can mark an item as completed" do
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(task.reload.completed).to eq true
        expect(resp_attrs["completed"]).to eq true
      end
    end

    context "when sender is not signed in" do
      before do
        put "/api/tasks/#{task.id}", params: put_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when incorrect user is signed in" do
      before do
        sign_in create(:user)
        put "/api/tasks/#{task.id}", params: put_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/tasks/:id" do
    let(:task) { create(:task) }

    context "when sender is signed in" do
      before do
        sign_in task.user
        delete "/api/tasks/#{task.id}"
      end

      it "should get a no content (204) response" do
        expect(response).to have_http_status(:no_content)
      end

      it "should destroy the record" do
        expect(Task.count).to eq 0
      end
    end

    context "when sender is not signed in" do
      before do
        delete "/api/tasks/#{task.id}"
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when incorrect user is signed in" do
      before do
        sign_in create(:user)
        delete "/api/tasks/#{task.id}"
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
