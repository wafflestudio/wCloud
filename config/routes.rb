WCloud::Application.routes.draw do
  devise_for :admins, :path => "admin", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :path => "/user", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}

  ## INSTANCE
  post "/instances/new" => "instances#new", :as => "new_instance"
  resources :instances, :except => [:new, :edit] do
    post "/edit" => "instances#edit", :on => :member
    post "/summary" => "instances#summary", :on => :member

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
  post "/disks/new" => "disks#new", :as => "new_disk"
  resources :disks, :except => [:new, :edit] do
    post "/new" => "disks#new", :on => :collection, :as => "new_disk"
    post "/edit" => "disks#edit", :on => :member
    post "/summary" => "disks#summary", :on => :member

    put "/attach" => "disks#attach", :on => :member
    get "/detach" => "disks#detach", :on => :member
  end

  ## SNAPSHOT
  resources :snapshots, :only => [:index, :edit, :update] do
  end

  ## NETWORK
  resources :networks, :only => [:index, :show, :update] do
    post "/edit" => "networks#edit", :on => :member
    post "/summary" => "networks#summary", :on => :member
  end

  ## TEMPLATE
  post "/templates/new" => "templates#new", :as => "new_template"
  resources :templates, :except => [:new, :edit] do
    post "/edit" => "templates#edit", :on => :member
    post "/summary" => "templates#summary", :on => :member
  end

  ## USAGE
  resources :usages, :only => [:index] do
  end

  root :to => "main#home"
  match "/about" => "main#about"
  match "/developers" => "main#devlopers"
end
