Rails.application.routes.draw do

  if Rails.env.production?
    root 'pages#client_freeze'
  else
    root 'vita_intake/welcome#edit'
  end
  get '/file_online' => 'pages#file_online', as: 'file_online'
  get '/chat_support' => 'pages#chat_support', as: 'chat_support'
  get '/front_upload_test' => 'front_upload_test#new'
  post '/front_upload' => 'front_upload_test#upload', as: 'front_upload'
  get '/interview/:unique_token' => 'research_contacts#appointment', as: 'interview_appointment'

  resource :reminder_contact do
    get 'new'
    post 'create'
    get 'thanks'
  end

  resource :research_contact do
    get 'invitation'
    get 'new'
    post 'create'
    get 'thanks'
  end

  namespace :redirects do
    get 'my_free_taxes'
    get 'get_ahead_colorado_locations'
  end

  resources :vita_admin, controller: 'vita_admin', only: [:index, :new, :create]

  resources :screens, controller: :eitc_estimate_forms, only: (Rails.env.production? ? %i[show] : %i[show index]) do
    collection do
      FormNavigation.form_controllers.uniq.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
                action: action,
                controller: controller_class.controller_path,
                via: method
        end
      end
    end
  end

  resources :research, controller: :research_signup_forms, only: (Rails.env.production? ? %i[show] : %i[show index]) do
    collection do
      ResearchFormNavigation.form_controllers.uniq.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
                action: action,
                controller: controller_class.controller_path,
                via: method
        end
      end
    end
  end

  resources :vita_intake, controller: :vita_intake_forms, only: (Rails.env.production? ? %i[show] : %i[show index]) do
    collection do
      VitaIntakeNavigation.all_form_controllers.uniq.each do |controller_class|
        { get: :edit, put: :update, delete: :destroy }.each do |method, action|
          match "/#{controller_class.to_param}",
                action: action,
                controller: controller_class.controller_path,
                via: method
        end
      end
    end
  end

  resources :vita_signing, controller: :vita_signing_forms, param: :unique_key, only: (Rails.env.production? ? %i[show] : %i[show index]) do
    collection do
      VitaSigningNavigation.all_form_controllers.uniq.each do |controller_class|
        { get: :edit, put: :update, delete: :destroy }.each do |method, action|
          match "/#{controller_class.to_param}",
                action: action,
                controller: controller_class.controller_path,
                via: method
        end
      end
    end
  end

  mount Cfa::Styleguide::Engine => "/cfa"
end
