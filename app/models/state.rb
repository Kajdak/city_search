# frozen_string_literal: true

class State < ApplicationRecord
  has_many :cities, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true
end
