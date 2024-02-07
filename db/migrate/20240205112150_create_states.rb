# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[5.2]
  def change
    create_table :states, id: :uuid do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false

      t.timestamps
    end

    add_index :states, :name, unique: true
    add_index :states, :abbreviation, unique: true
  end
end
