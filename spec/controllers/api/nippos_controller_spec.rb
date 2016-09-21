# frozen_string_literal: true
RSpec.describe Api::NipposController do
  describe 'Unauthorized Error' do
    it 'returns error' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'when login successful' do
    let(:token) { double acceptable?: true }
    let(:user) { FG.create(:user) }
    before do
      controller.stub(:doorkeeper_token) { token }
      controller.stub(:current_user) { user }
      @nippo = FG.create(:nippo, sent_at: Time.zone.now)
    end
    describe 'GET index' do

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

    describe 'GET new' do
      it 'returns OK and shows template' do
        get :new
        expect(response).to have_http_status(:success)
        expect(assigns(:nippo)).to be_present
        expect(assigns(:nippo).body).to eq current_user.template.body
        expect(assigns(:nippo).reported_for).to be_present
      end
    end

    describe 'POST create' do
      it 'creates new nippo', :vcr do
        expect do
          post :create, params: {
                          nippo: {
                              reported_for: Time.zone.today,
                              body: FFaker::Lorem.paragraph,
                          },
                      }
        end.to change(Nippo, :count).by(1)
      end

      context 'when nippo is invalid' do
        it 'show alert and form' do
          post :create, params: {
                          nippo: {
                              reported_for: Time.zone.today,
                              body: '',
                          },
                      }
          expect(flash[:alert]).to be_present
          expect(response).to render_template(:new)
        end
      end

      context 'when NippoSender#run fails' do
        let(:sender) { double('NippoSender') }
        let(:errors) { double('errors') }

        it 'redirects to nippo#show' do
          allow(NippoSender).to receive(:new) { sender }
          allow(sender).to receive(:run) { nil }
          allow(sender).to receive(:errors) { errors }
          allow(errors).to receive(:full_messages) { 'error!' }

          post :create, params: {
                          nippo: {
                              reported_for: Time.zone.today,
                              body: FFaker::Lorem.paragraph,
                          },
                      }

          expect(response).to redirect_to(nippo_path(assigns(:nippo)))
        end
      end
    end

    describe 'PATCH update' do
      let(:nippo) { FG.create(:nippo, user: current_user) }

      it 'updates nippo', :vcr do
        expect do
          patch :update, params: { id: nippo.id, nippo: { body: 'changed' } }
          nippo.reload
        end.to change(nippo, :body).and change(nippo, :status).from('draft').to('sent')
      end

      context 'when nippo is invalid' do
        it 'show alert and form' do
          patch :update, params: { id: nippo.id, nippo: { body: '' } }
          expect(flash[:alert]).to be_present
          expect(response).to render_template(:show)
        end
      end

      context 'nippo has already sent' do
        before { nippo.update(status: :sent) }

        it 'redirects show' do
          patch :update, params: { id: nippo.id, nippo: { body: 'changed' } }
          expect(response).to redirect_to(nippo_path(nippo))
        end
      end

      context 'when nippo is owned by other' do
        let(:nippo) { FG.create(:nippo) }

        it 'returns 404' do
          expect { patch :update, params: { id: nippo.id, nippo: { body: 'changed' } } }
              .to raise_error(ActionController::RoutingError)
        end
      end
    end

    describe 'GET show' do
      let(:nippo) { FG.create(:nippo, user: current_user) }

      context 'when nippo is draft' do
        it 'does NOT create reaction object' do
          expect { get :show, params: { id: nippo.id } }
              .not_to change { Reaction.find_by(user: current_user, nippo: nippo)&.page_view || 0 }
          expect(assigns(:nippo)).to eq nippo
        end

        context 'when nippo is owned by other' do
          let(:nippo) { FG.create(:nippo) }
          it 'returns 404' do
            expect { get :show, params: { id: nippo.id } }.to raise_error(ActionController::RoutingError)
          end
        end
      end

      context 'when nippo was sent' do
        let(:nippo) { FG.create(:nippo, status: :sent) }

        it 'creates reaction object and sets pv as 1' do
          get :show, params: { id: nippo.id }
          expect(Reaction.find_by(user: current_user, nippo: nippo).page_view).to eq 1
        end

        it 'increment existing reaction page view' do
          get :show, params: { id: nippo.id }
          expect { get :show, params: { id: nippo.id } }
              .to change { Reaction.find_by(user: current_user, nippo: nippo).page_view }.by(1)
        end
      end
    end
  end
end
