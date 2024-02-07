# frozen_string_literal: true

require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      state = State.new(abbreviation: 'SP')
      expect(state.valid?).to be(false)
      expect(state.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of abbreviation' do
      state = State.new(name: 'São Paulo')
      expect(state.valid?).to be(false)
      expect(state.errors[:abbreviation]).to include("can't be blank")
    end
  end
end
