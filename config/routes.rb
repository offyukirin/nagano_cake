Rails.application.routes.draw do
  
# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
   root 'public/homes#top'
   
   get "about" => "public/homes#about"
   get "customers" =>"public/"
  namespace :admin do
   resources :items
   resources :customers 
   resources :genres, only: [:index, :create, :edit, :update]
   resources :orders, only: [:index, :show, :update]
   resources :order_details, only:[:update]
  end
  
  namespace :public do
   
   delete 'cart_items/destroy_all' => 'cart_items#destroy_all'
   
   resources :genres
   resources :items
   resources :cart_items
   
   get 'orders/complete' => "orders#complete"
   get 'orders/confirm' => "orders#confirm"
   post 'orders/confirm'
    
   resources :customers do
      member do
        get "unsubscribe"
        patch "withdraw"
      end
    end
   resources :homes,only: [:top,:about]
   resources :addresses,only: [:index,:create,:edit,:update,:destroy]
   resources :orders,only: [:index, :new, :create, :complete, :show, ]
   

    
  end

end
