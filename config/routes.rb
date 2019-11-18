# frozen_string_literal: true

DiscourseTeambuild::Engine.routes.draw do
  get '/' => 'teambuild#index'
  get '/about' => 'teambuild#index'
  get '/scores' => 'teambuild#scores'
  get '/manage' => 'teambuild#index'
  # get '/goals' => 'teambuild#goals'
  # get '/goals/:username' => 'teambuild#goals', constraints: { username: RouteFormat.username }
  put '/complete/:goal_id' => 'teambuild#complete'
  delete '/undo/:goal_id' => 'teambuild#undo'

  get "/targets" => 'targets#index'
  post "/targets" => 'targets#create'
  delete "/targets/:id" => 'targets#destroy'
  put "/targets/:id" => 'targets#update'
  put "/targets/:id/swap-position" => 'targets#swap_position'
end
