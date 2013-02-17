WCloud::Application.routes.draw do
  devise_for :admins, :path => "admin", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :path => "/user", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}

  ## INSTANCE
  resources :instances do
    post "/stop" => "instances#stop", :on => :member
    post "/start" => "instances#start", :on => :member
    post "/reboot" => "instances#reboot", :on => :member
    post "/forcestop" => "instances#forcestop", :on => :member
    post "/forcereboot" => "instances#forcereboot", :on => :member
    post "/snapshot" => "instances#snapshot", :on => :member
    post "/restore" => "instances#restore", :on => :member
    post "/duplicate" => "instances#duplicate", :on => :member
    get "/update_state" => "instances#update_state", :on => :collection
  end

  ## DISK
  resources :disks do
    put "/attach" => "disks#attach", :on => :member
    get "/detach" => "disks#detach", :on => :member
  end

  ## SNAPSHOT
  resources :snapshots, :only => [:index, :edit, :update] do
  end

  ## NETWORK
  resources :networks, :only => [:index, :edit, :update] do
  end

  ## TEMPLATE
  resources :templates do
  end

  ## USAGE
  resources :usages, :only => [:index] do
  end

  root :to => "main#home"
  match "/about" => "main#about"
  match "/developers" => "main#devlopers"
end
