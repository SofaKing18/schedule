require 'rails_helper'

RSpec.describe StaticPageController, type: :controller do
  describe 'GET #main allowed after authenticate' do
    it 'returns http success' do
      get :main
      expect(response).to have_http_status(:redirect)
    end
  end
  describe 'GET #main' do
    it 'returns http success' do
      subject.class.skip_before_action :authenticate_user!
      get :main
      expect(response).to have_http_status(:success)
    end
  end
end
