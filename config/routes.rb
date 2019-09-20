# frozen_string_literal: true

DiscourseTeambuild::Engine.routes.draw do
  get '/' => 'teambuild#index'
  get '/about' => 'teambuild#index'
  get '/goals' => 'teambuild#goals'
end
