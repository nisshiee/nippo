# frozen_string_literal: true
RSpec.describe Api::NipposController do
  describe 'Unauthorized Error' do
    it 'returns error' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET index' do
    let(:token) { double acceptable?: true }
    let(:user) { FG.create(:user) }
    before do
      controller.stub(:doorkeeper_token) { token }
      controller.stub(:current_user) { user }
      @nippo = FG.create(:nippo, sent_at: Time.zone.now)
    end

    it 'returns success' do
      get :index
      expect(response).to have_http_status(:success)
      @json = JSON.parse(response.body)
      @json.map do |nippo|
        expect(nippo['subject']).to eq @nippo.subject
        expect(nippo['body']).to eq @nippo.body
      end
    end
  end
end
