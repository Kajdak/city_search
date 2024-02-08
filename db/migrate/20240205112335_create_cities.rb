# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities, id: :uuid do |t|
      t.string :name, null: false
      t.references :state, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
