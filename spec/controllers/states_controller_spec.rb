# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all states' do
      state1 = State.create(name: 'São Paulo', abbreviation: 'SP')
      state2 = State.create(name: 'Rio de Janeiro', abbreviation: 'RJ')

      get :index
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(parsed_response).to include(JSON.parse(state1.to_json), JSON.parse(state2.to_json))
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      state = State.create(name: 'São Paulo', abbreviation: 'SP')

      get :show, params: { id: state.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns the state' do
      state = State.create(name: 'São Paulo', abbreviation: 'SP')

      get :show, params: { id: state.id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq(state.name)
      expect(parsed_response['abbreviation']).to eq(state.abbreviation)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'Rio de Janeiro', abbreviation: 'RJ' } } }

      it 'creates a new state' do
        expect { post :create, params: valid_attributes }.to change(State, :count).by(1)
      end

      it 'returns the created state' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(valid_attributes[:state][:name])
        expect(parsed_response['abbreviation']).to eq(valid_attributes[:state][:abbreviation])
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { state: { name: '', abbreviation: 'RJ' } } }

      it 'does not create a new state' do
        expect { post :create, params: invalid_attributes }.not_to change(State, :count)
      end

      it 'returns the state errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('name')
      end
    end
  end

  describe 'PATCH #update' do
    let(:state) { State.create(name: 'Saint Paul', abbreviation: 'SP') }

    context 'with valid attributes' do
      let(:valid_attributes) { { state: { name: 'São Paulo', abbreviation: 'SP' } } }

      it 'updates the state' do
        patch :update, params: { id: state.id, state: valid_attributes[:state] }
        state.reload
        expect(state.name).to eq(valid_attributes[:state][:name])
      end

      it 'returns the updated state' do
        patch :update, params: { id: state.id, state: valid_attributes[:state] }
        expect(response).to have_http_status(:success)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq(valid_attributes[:state][:name])
      end
    end

    context 'with invalid attributes' do
      it 'does not update the state' do
        original_name = state.name
        patch :update, params: { id: state.id, state: { name: '' } }
        state.reload
        expect(state.name).to eq(original_name)
      end

      it 'returns the state errors' do
        patch :update, params: { id: state.id, state: { name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('name')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }

    it 'destroys the state' do
      expect { delete :destroy, params: { id: state.id } }.to change(State, :count).by(-1)
    end

    it 'returns no content' do
      delete :destroy, params: { id: state.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
