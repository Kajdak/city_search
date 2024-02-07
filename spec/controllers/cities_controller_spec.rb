# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CitiesController, type: :controller do
  before(:each) do
    City.destroy_all
    State.destroy_all
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }
    let!(:city) { City.create(name: 'Itapetininga', state: state) }

    it 'returns http success' do
      get :show, params: { id: city.id }
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct city JSON' do
      get :show, params: { id: city.id }
      expected_response = { 'id' => city.id, 'name' => city.name, 'state_id' => state.id }
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(expected_response)
    end
  end

  describe 'POST #create' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }

    context 'with valid attributes' do
      let(:valid_attributes) { { city: { name: 'Itapetininga', state_id: state.id } } }

      it 'creates a new city' do
        expect { post :create, params: valid_attributes }.to change(City, :count).by(1)
      end

      it 'returns the created city JSON' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.body).to eq(City.last.to_json)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { city: { name: '' } } }

      it 'does not create a new city' do
        expect { post :create, params: invalid_attributes }.not_to change(City, :count)
      end

      it 'returns the city errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(City.last.errors.to_json)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }
    let!(:city) { City.create(name: 'Itapetininga', state: state) }

    context 'with valid attributes' do
      let(:valid_attributes) { { city: { name: 'Ourinhos', state_id: state.id } } }

      it 'updates the city name' do
        patch :update, params: { id: city.id, city: { name: 'Ourinhos', state_id: state.id } }
        city.reload
        expect(city.name).to eq('Ourinhos')
      end

      it 'returns the updated city JSON' do
        patch :update, params: { id: city.id, city: { name: 'Ourinhos', state_id: state.id } }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(city.reload.to_json)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { { city: { name: '' } } }

      it 'does not update the city name' do
        patch :update, params: { id: city.id, city: { name: '', state_id: state.id } }
        city.reload
        expect(city.name).to eq('Itapetininga')
      end

      it 'returns the city errors' do
        patch :update, params: { id: city.id, city: { name: '', state_id: state.id } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(city.reload.errors.to_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }
    let!(:city) { City.create(name: 'Itapetininga', state: state) }

    it 'destroys the city' do
      expect { delete :destroy, params: { id: city.id } }.to change(City, :count).by(-1)
    end

    it 'returns http no content' do
      delete :destroy, params: { id: city.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET #search' do
    let!(:state) { State.create(name: 'São Paulo', abbreviation: 'SP') }
    let!(:city1) { City.create(name: 'Itapetininga', state: state) }
    let!(:city2) { City.create(name: 'Ourinhos', state: state) }

    context 'without state_id and name parameters' do
      it 'returns all cities' do
        get :search
        expect(response).to have_http_status(:success)
        expect(assigns(:cities)).to match_array([city1, city2])
      end
    end

    context 'with state_id parameter' do
      it 'returns cities filtered by state_id' do
        get :search, params: { state_id: state.id }
        expect(response).to have_http_status(:success)
        expect(assigns(:cities)).to match_array([city1, city2])
      end
    end

    context 'with name parameter' do
      it 'returns cities filtered by name' do
        get :search, params: { name: 'Itapetininga' }
        expect(response).to have_http_status(:success)
        expect(assigns(:cities)).to match_array([city1])
      end
    end

    context 'with state_id and name parameters' do
      it 'returns cities filtered by state_id and name' do
        get :search, params: { state_id: state.id, name: 'Ourinhos' }
        expect(response).to have_http_status(:success)
        expect(assigns(:cities)).to match_array([city2])
      end
    end
  end
end