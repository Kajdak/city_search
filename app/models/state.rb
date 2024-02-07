# frozen_string_literal: true

class State < ApplicationRecord
  has_many :cities
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true
end
