WCloud::Application.routes.draw do
  devise_for :admins, :path => "admin", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :path => "/user", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}

  ## INSTANCE
  resources :instances do
    get "/stop" => "instances#stop", :on => :member
    get "/start" => "instances#start", :on => :member
    get "/reboot" => "instances#reboot", :on => :member
    get "/forcestop" => "instances#forcestop", :on => :member
    get "/forcereboot" => "instances#forcereboot", :on => :member
    get "/snapshot" => "instances#snapshot", :on => :member
    put "/restore" => "instances#restore", :on => :member
    get "/duplicate" => "instances#duplicate", :on => :member
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

  root :to => "main#home"
end
