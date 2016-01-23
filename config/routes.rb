Selfstarter::Application.routes.draw do
  root :to => 'preorder#index'
  get '/preorder'           => 'preorder#index'
  get '/preorder/order'        => 'preorder#checkout'
  post '/preorder/order'       => 'preorder#order'
  post '/preorder/printfulcall' => 'preorder#printfulcall'

  get '/preorder/share/:uuid' => 'preorder#share', as: :share
  post '/preorder/ipn'       => 'preorder#ipn'
end
