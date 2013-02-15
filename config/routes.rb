WCloud::Application.routes.draw do
  devise_for :admins, :path => "admin", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users, :path => "/user", :path_names => {:sign_up => "signup", :sign_in => "signin", :sign_out => "signout"}

root :to => "main#home"
end
