Rails.application.routes.draw do
  get 'automorph/index'
  get 'automorph/result'
  root 'automorph#index'
end
