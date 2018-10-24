require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    context 'when user is logged in' do
      login_user

      before(:each) do
        get :index
      end

      it "should have a current_user" do
        expect(subject.current_user).to_not eq(nil)
      end

      it "should get a successful (200) response" do
        expect(response).to have_http_status(:ok)
      end

      it "should get the index template" do
        expect(subject).to render_template(:index)
      end

      it "should have HTML content" do
        expect(response.content_type).to eq "text/html"
      end

      it "should render the application layout" do
        expect(subject).to render_template(layout: :application)
      end
    end

    context 'when user is logged out' do
      before do
        get :index
      end

      it "should redirect to sign in page" do
        expect(subject).to redirect_to(new_user_session_path)
      end

      it "should not have a current user" do
        expect(subject.current_user).to eq(nil)
      end

    end

    context "when multiple users have tasks" do
      let(:user) { create(:user) }

      login_user

      before(:each) do
        current_user = User.first
        @authorized_task = create(:task, user: current_user)
        @unauthorized_task = create(:task, user: user)
      end

      it "returns only tasks that belong to that user" do
        get :index

        expect(assigns :tasks).to include(@authorized_task)
        expect(assigns :tasks).to_not include(@unauthorized_task)
      end
    end
  end
end
