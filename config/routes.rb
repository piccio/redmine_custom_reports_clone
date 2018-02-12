# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
RedmineApp::Application.routes.draw do
  resources :projects do
    resources :custom_reports_clones, only: [:new, :create]
  end
end
