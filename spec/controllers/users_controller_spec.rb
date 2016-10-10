require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    subject { get :new }
    it 'should render new view' do
      expect(subject).to render_template(:new)
    end
  end

  describe 'POST#create' do
    context 'with invalid params' do
      it 'validates the presence of username and password' do
        post :create, user: {username: 'invalid', password: ''}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
      it 'validates the length of password' do
        post :create, user: {username: 'invalid', password: 'inval'}
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end

    it 'should redirect to user show page if params are valid' do
      post :create, user: {username: 'valid', password: 'sovalid'}
      expect(response).to redirect_to(user_url(User.last))
    end
  end

  describe '#show' do
    subject { get :show, id: 1 }
    it 'should show' do
      expect(subject).to render_template(:show)
    end
  end
end
