Selfstarter::Application.routes.draw do
  root :to => 'preorder#index'
  match '/preorder'               => 'preorder#index', :via => [:get,:post]
  get 'preorder/checkout'
  match '/preorder/share/:uuid'   => 'preorder#share', :via => :get
  match '/preorder/ipn'           => 'preorder#ipn', :via => :post
  match '/preorder/prefill'       => 'preorder#prefill', :via => [:get,:post]
  match '/preorder/postfill'      => 'preorder#postfill', :via => [:get,:post]
  namespace 'admin' do
    root :to => 'dashboard#show'
    resource :dashboard, only: :show, controller: :dashboard
  end
end
