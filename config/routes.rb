# frozen_string_literal: true

DiscourseTeambuild::Engine.routes.draw do
  get '/' => 'teambuild#index'
  get '/about' => 'teambuild#index'
  get '/scores' => 'teambuild#scores'
  get '/goals' => 'teambuild#goals'
  get '/goals/:username' => 'teambuild#goals', constraints: { username: RouteFormat.username }
  put '/complete/:goal_id' => 'teambuild#complete'
  delete '/undo/:goal_id' => 'teambuild#undo'
end
