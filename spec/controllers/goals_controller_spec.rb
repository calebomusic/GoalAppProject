require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:billybob) { User.create(username: 'BillyBob', password: 'password')}
  let(:snoopy) { User.create(username: "snoopy", password: "password")}

  describe "GET#new" do
    context 'logged in' do
      before do
        allow(controller).to receive(:current_user) { billybob }
      end
      it 'should render new page' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        get :new
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'POST#create' do
    context 'logged in' do
      before do
        allow(controller).to receive(:current_user) { billybob }
      end
      it 'renders new page with invalid params' do
        post :create, goal: { description: 'title', private: false }
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it 'redirects to goal#show page with valid params' do
        post :create, goal: { description: 'title', private: false, status:false, user_id: User.first.id }
        expect(response).to redirect_to(goal_url(Goal.last.id))
      end
    end

    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        post :create
        expect(response).to redirect_to(new_session_url)
      end
    end
  end

  describe 'GET#edit' do
    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        get :edit, Goal.last.id
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'logged in' do
      before do
        allow(controller).to receive(:current_user) { billybob }
      end

      it "should render edit page" do
        let(:goal) { Goal.create(description: "hello", private: false, status: false, user_id: billybob.id) }
        get :edit, Goal.last.id
        expect(response).to render_template(:edit)
      end

      it "shouldn't let other users edit goals" do
        let(:goal) { Goal.create(description: "hello", private: false, status: false, user_id: snoopy.id) }
        get :edit, Goal.last.id
        expect(response).to redirect_to(goals_url)
      end
    end
  end

  describe 'PATCH#update' do
    let(:goal) { Goal.create(description: "hello", private: false, status: false, user_id: snoopy.id) }
    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        patch :update, id: Goal.last.id
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'logged in' do
      before do
        allow(controller).to receive(:current_user) { billybob }
      end

      it 'renders edit page with invalid params' do
        patch :update, goal: { description: nil, private: false }, id: Goal.last.id
        expect(response).to render_template(:edit)
        expect(flash[:errors]).to be_present
      end

      it 'redirects to goal#show page with valid params' do
        patch :update, goal: { description: 'title', private: true, status:false, user_id: billybob.id }
        expect(response).to redirect_to(goal_url(Goal.last.id))
      end

      it "shouldn't let other users update goals" do
        patch :update, goal: { description: 'title', private: true, status:false, user_id: billybob.id }
        expect(response).to redirect_to(goals_url)
        expect(Goal.last.description).to eq("hello")
      end
    end
  end

  describe 'GET#index' do
    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'should redirect to log in page' do
        get :index
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'logged in' do
      before do
        allow(controller).to receive(:current_user) { billybob }
      end
      it 'renders index page' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        delete :destroy, Goal.last.id
        expect(response).to redirect_to(new_session_url)
      end
    end

    context 'logged in' do
        before do
          allow(controller).to receive(:current_user) { billybob }
        end

        it 'deletes a goal' do
          delete :destroy, Goal.last.id
          expect(response).to redirect_to(goals_url)
        end
    end
  end

  describe 'GET#show' do
    context 'logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end
      it 'should redirect to log in page' do
        get :show, Goal.last.id
        expect(response).to redirect_to(new_session_url)
      end
    end
  end
end
