require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/profiles/me', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at admin updated_at).each do |att|
        it "contains #{att}" do
          expect(response.body).to be_json_eql(me.send(att.to_sym).to_json).at_path(att)
        end
      end

      %w(password encrypted_password).each do |att|
        it "does not containt #{att}" do
          expect(response.body).to_not have_json_path(att)
        end
      end
    end
  end

  describe 'GET index' do
    context 'unauthorized' do
      it 'returns 401 status if no access_token' do
        get '/api/v1/profiles', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/profiles', format: :json, access_token: '123'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:requesting_user) { create(:user) }
      let!(:users) { create_list :user, 3 }
      let(:access_token) { create(:access_token, resource_owner_id: requesting_user.id) }

      before { get '/api/v1/profiles', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'contains a list of users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'not containts requesting user' do
        expect(response.body).not_to include_json(requesting_user.to_json)
      end
    end
  end
end
