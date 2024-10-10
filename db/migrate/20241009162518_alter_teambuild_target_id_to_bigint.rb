# frozen_string_literal: true

class AlterTeambuildTargetIdToBigint < ActiveRecord::Migration[7.1]
  def up
    change_column :teambuild_target_users, :teambuild_target_id, :bigint
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
