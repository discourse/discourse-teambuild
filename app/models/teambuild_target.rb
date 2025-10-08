# frozen_string_literal: true

class TeambuildTarget < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :teambuild_target_users, dependent: :destroy

  before_create :default_position
  validates :name, uniqueness: true
  default_scope { order(:position) }

  validates :group_id,
            presence: true,
            if: -> { target_type_id == TeambuildTarget.target_types[:user_group] }

  def self.target_types
    @target_types ||= Enum.new(regular: 1, user_group: 2)
  end

  # This is not safe under concurrency, but it's unlikely someone will be creating
  # targets that actively.
  def default_position
    self.position = (TeambuildTarget.maximum(:position) || 0) + 1
  end
end

# == Schema Information
#
# Table name: teambuild_targets
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  target_type_id :integer          not null
#  group_id       :integer
#  position       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_teambuild_targets_on_name      (name) UNIQUE
#  index_teambuild_targets_on_position  (position) UNIQUE
#
