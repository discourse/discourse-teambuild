# frozen_string_literal: true

class CreateTeambuildTargetUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :teambuild_target_users do |t|
      t.integer :user_id, null: false
      t.integer :teambuild_target_id, null: false
      t.integer :target_user_id, null: false
      t.timestamps null: false
    end

    add_index :teambuild_target_users,
              %i[user_id teambuild_target_id target_user_id],
              name: :teambuild_unique_choice,
              unique: true
  end
end
