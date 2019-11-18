# frozen_string_literal: true

class TeambuildTarget < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  before_create :default_position
  validates_uniqueness_of :name
  default_scope { order(:position) }

  validates :group_id, presence: true, if: -> { target_type_id == TeambuildTarget.target_types[:user_group] }

  def self.target_types
    @target_types ||= Enum.new(regular: 1, user_group: 2)
  end

  # This is not safe under concurrency, but it's unlikely someone will be creating
  # targets that actively.
  def default_position
    self.position = (TeambuildTarget.maximum(:position) || 0) + 1
  end

end
