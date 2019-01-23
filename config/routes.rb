Rails.application.routes.draw do
  root 'pages#index'
  get '/about' => 'pages#about', as: 'about'
  get '/help_sites' => 'pages#help_sites', as: 'help_sites'
  get '/file_online' => 'pages#file_online', as: 'file_online'
  get '/reminder' => 'pages#reminder', as: 'reminder'
  get '/file_late' => 'pages#file_late', as: 'file_late'

  resource :reminder_contact do
    get 'new'
    post 'create'
    get 'thanks'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Cfa::Styleguide::Engine => "/cfa"
end
