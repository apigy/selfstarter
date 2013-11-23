Selfstarter::Application.routes.draw do
  root :to => 'preorder#index'
  match '/preorder'           => 'preorder#index', :via => [:get,:post]
  get 'preorder/order'        => 'preorder#checkout'
  post 'preorder/order'       => 'preorder#order'

  match '/preorder/share/:uuid' => 'preorder#share', :via => :get
  match '/preorder/ipn'       => 'preorder#ipn', :via => :post
end
