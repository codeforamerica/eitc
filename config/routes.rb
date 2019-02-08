Rails.application.routes.draw do
  root 'filing_status#edit'
  get '/file_online' => 'pages#file_online', as: 'file_online'

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
