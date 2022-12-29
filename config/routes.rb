# frozen_string_literal: true

DiscourseTeambuild::Engine.routes.draw do
  get "/" => "teambuild#index"
  get "/scores" => "teambuild#scores"
  get "/manage" => "teambuild#index", :constraints => StaffConstraint.new
  get "/progress" => "teambuild#progress"
  get "/progress/:username" => "teambuild#progress",
      :constraints => {
        username: RouteFormat.username,
      }
  put "/complete/:target_id/:user_id" => "teambuild#complete"
  delete "/undo/:target_id/:user_id" => "teambuild#undo"

  resources :targets, constraints: StaffConstraint.new do
    put "/swap-position" => "targets#swap_position"
  end
end
