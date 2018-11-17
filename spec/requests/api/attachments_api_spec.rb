require 'rails_helper'

RSpec.describe "Attachments API", type: :request do
  let(:task) { create(:task) }
  let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_file.jpeg')) }
  let(:post_params) do
    {
      attachment_file: file,
      task_id: task.id 
    }
  end

  describe "POST /api/attachments" do
    context "when sender is signed in" do
      before do
        sign_in task.user
        post "/api/attachments", params: post_params
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "responds with json by default" do
        expect(response.content_type).to eq "application/vnd.api+json"
      end

      it "creates one record" do
        expect(task.attachments.count).to eq 1
      end

      it "has the POSTed attributes in the response body" do
        resp_attrs = JSON.parse(response.body)["data"]["attributes"]
        expect(resp_attrs["filename"]).to eq file.original_filename
      end
    end

    context "when sender is not signed in" do
      before do
        post "/api/attachments", params: post_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when incorrect user is signed in" do
      before do
        sign_in create(:user)
        post "/api/attachments", params: post_params
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/attachments/:id" do
    let(:task) { create(:task, :with_attachment) }
    let(:attachment) { task.attachments.first }

    context "when sender is signed in" do
      before do
        sign_in task.user
        delete "/api/attachments/#{attachment.id}"
      end

      it "should get a no content (204) response" do
        expect(response).to have_http_status(:no_content)
      end

      it "should destroy the record" do
        expect(task.attachments.count).to eq 0
      end
    end

    context "when sender is not signed in" do
      before do
        delete "/api/attachments/#{attachment.id}"
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when incorrect user is signed in" do
      before do
        sign_in create(:user)
        delete "/api/attachments/#{attachment.id}"
      end

      it "returns http redirect" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
