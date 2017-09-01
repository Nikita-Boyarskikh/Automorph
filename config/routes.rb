Rails.application.routes.draw do
  get 'automorph/index'
  get 'automorph/result'
  root to: 'automorph#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
