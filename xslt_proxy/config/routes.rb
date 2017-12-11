Rails.application.routes.draw do
  get 'proxy/input'
  get 'proxy/output'
  root 'proxy#input'
end
