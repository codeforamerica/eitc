Rails.application.routes.draw do
  root 'filing_status#edit'
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

  mount Cfa::Styleguide::Engine => "/cfa"
end
