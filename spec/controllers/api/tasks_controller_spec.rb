require 'rails_helper'

RSpec.describe Api::TasksController, type: :controller do
  describe "POST #create" do
    let(:post_params) do
      {
        task: {
          description: "Booyah",
          due: Time.now
        }
      }
    end
    context "when sender is logged in" do
      login_user

      before do
        frozen_time = Time.local(2020, 11, 3, 0, 0, 0)
        Timecop.freeze(frozen_time)
        post :create, params: post_params
      end

      after do
        Timecop.return
      end

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end

      it "responds to json by default" do
        expect(response.content_type).to eq "application/vnd.api+json"
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "one task should be created" do
        expect(Task.count).to eq 1
      end

      it "the response body has the POSTed attributes" do
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(resp_attrs["description"]).to eq post_params[:task][:description]
        expect(resp_attrs["due"].to_datetime).to eq post_params[:task][:due].to_datetime
      end
    end

    context "when sender is not logged in" do
      before do
        post :create, params: post_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "PUT #update" do
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
    context "when sender is logged in" do
      login_user

      before do
        frozen_time = Time.local(2020, 11, 3, 0, 0, 0)
        Timecop.freeze(frozen_time)
        put :update, params: put_params.merge(id: task.id)
      end

      after do
        Timecop.return
      end

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end

      it "responds to json by default" do
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
        expect(task.completed).to eq false
        put :update, params: {id: task.id, task: { completed: true } }
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(task.reload.completed).to eq true
        expect(resp_attrs["completed"]).to eq true
      end
    end

    context "when sender is not logged in" do
      before do
        put :update, params: put_params.merge(id: task.id)
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:task) { create(:task) }

    context "when sender is logged in" do
      login_user

      it "should get a no content (204) response" do
        task
        delete :destroy, params: { id: task.id }
        expect(response).to have_http_status(:no_content)
      end

      it "should destroy the record" do
        task
        expect(Task.count).to eq 1
        delete :destroy, params: { id: task.id }
        expect(Task.count).to eq 0
      end
    end

    context "when sender is not logged in" do
      it "returns http redirect" do
        delete :destroy, params: { id: task.id }
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
