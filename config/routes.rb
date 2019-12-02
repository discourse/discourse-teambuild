# frozen_string_literal: true

DiscourseTeambuild::Engine.routes.draw do
  get '/' => 'teambuild#index'
  get '/scores' => 'teambuild#scores'
  get '/manage' => 'teambuild#index'
  get "/progress" => 'teambuild#progress'
  get "/progress/:username" => 'teambuild#progress', constraints: { username: RouteFormat.username }
  put '/complete/:target_id/:user_id' => 'teambuild#complete'
  delete '/undo/:target_id/:user_id' => 'teambuild#undo'

  get "/targets" => 'targets#index'
  post "/targets" => 'targets#create'
  delete "/targets/:id" => 'targets#destroy'
  put "/targets/:id" => 'targets#update'
  put "/targets/:id/swap-position" => 'targets#swap_position'
end
