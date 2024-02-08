# frozen_string_literal: true

require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'validations' do
    it 'name validation' do
      city = City.new(name: nil)
      expect(city.valid?).to be(false)
      expect(city.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs_to state' do
      association = described_class.reflect_on_association(:state)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'scopes' do
    let!(:sp) { State.create(name: 'São Paulo', abbreviation: 'SP') }
    let!(:rj) { State.create(name: 'Rio de Janeiro', abbreviation: 'RJ') }

    let!(:itapetininga) { City.create(name: 'Itapetininga', state: sp) }
    let!(:sp_sp) { City.create(name: 'São Paulo', state: sp) }
    let!(:rj_rj) { City.create(name: 'Rio de Janeiro', state: rj) }

    describe 'filter_by_state' do
      it 'returns cities filtered by state' do
        search = City.filter_by_state(sp.id)
        expect(search).to include(itapetininga, sp_sp)
        expect(search).not_to include(rj_rj)
      end
    end

    describe 'filter_by_name' do
      it 'returns cities filtered by name' do
        search = City.filter_by_name('ninga')
        expect(search).to include(itapetininga)
        expect(search).not_to include(rj_rj, sp_sp)
      end
    end

    describe 'filter_by_state_and_name' do
      it 'returns cities filtered by state and name' do
        search = City.filter_by_state(sp.id).filter_by_name('Itape')
        expect(search).to include(itapetininga)
        expect(search).not_to include(rj_rj, sp_sp)
      end
    end

    describe 'empty_results' do
      it 'returns empty results when no cities match the filters' do
        search = City.filter_by_state(rj.id).filter_by_name('Itape')
        expect(search).to be_empty
      end
    end
  end
end
