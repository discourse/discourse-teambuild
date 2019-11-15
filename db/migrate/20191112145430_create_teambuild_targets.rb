# frozen_string_literal: true

class CreateTeambuildTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :teambuild_targets do |t|
      t.string :name, null: false
      t.integer :target_type_id, null: false
      t.integer :group_id, null: true
      t.integer :position, null: false
      t.timestamps null: false
    end
  end
end
