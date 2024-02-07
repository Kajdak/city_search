# frozen_string_literal: true

class City < ApplicationRecord
  belongs_to :state

  validates :name, presence: true

  default_scope { order(name: :asc) }

  scope :filter_by_state, ->(state_id) { where(state_id: state_id) }
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
