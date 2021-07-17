Rails.application.routes.draw do
  resources :employees, :except => :destroy do
    get :search_employee
    delete :delete_employee
    patch :terminate

    resources :expense_groups, only: [:create, :destroy] do
      patch :update_status
      get :show_all_expenses
    end


    resources :expenses, except: [:update]
  end

  resources :expenses, only: [] do 
    patch :update_status
    resources :comments, only: [:index, :create] do
      post :reply_comment
      delete :delete_comment
    end
  end
end
