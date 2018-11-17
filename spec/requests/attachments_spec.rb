require 'rails_helper'

RSpec.describe "Attachments", type: :request do
  let(:task) { create(:task, :with_attachment) }
  let(:attachment) { task.attachments.first }

  describe "GET /attachments/:id" do
    context "when sender is signed in" do
      before do
        sign_in task.user
        get "/attachments/#{attachment.id}"
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "responds with an image" do
        expect(response.content_type).to eq "image/jpeg"
      end
    end

    context "when sender is not signed in" do
      before do
        get "/attachments/#{attachment.id}"
      end

      it "should get a redirect (302) response" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when incorrect user is signed in" do
      before do
        sign_in create(:user)
        get "/attachments/#{attachment.id}"
      end

      it "should get a forbidden (403) response" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
