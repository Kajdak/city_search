# frozen_string_literal: true

require 'test_helper'

class StateTest < ActiveSupport::TestCase
  test 'should have many cities' do
    state = State.new
    assert_respond_to state, :cities
  end

  test 'should validate presence and uniqueness of name' do
    state = State.new
    assert_not state.valid?
    assert_includes state.errors[:name], "can't be blank"

    state.name = 'California'
    assert state.valid?

    duplicate_state = State.new(name: 'California')
    assert_not duplicate_state.valid?
    assert_includes duplicate_state.errors[:name], 'has already been taken'
  end

  test 'should validate presence and uniqueness of abbreviation' do
    state = State.new
    assert_not state.valid?
    assert_includes state.errors[:abbreviation], "can't be blank"

    state.abbreviation = 'CA'
    assert state.valid?

    duplicate_state = State.new(abbreviation: 'CA')
    assert_not duplicate_state.valid?
    assert_includes duplicate_state.errors[:abbreviation], 'has already been taken'
  end
end
