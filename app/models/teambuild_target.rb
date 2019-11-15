# frozen_string_literal: true

class TeambuildTarget < ActiveRecord::Base
  belongs_to :user
  before_create :default_position

  # This is not safe under concurrency, but it's unlikely someone will be creating
  # targets that actively.
  def default_position
    self.position = (TeambuildTarget.maximum(:position) || 0) + 1
  end
end
