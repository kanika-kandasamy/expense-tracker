Rails.application.routes.draw do
  resources :comments
  resources :expenses
  resources :expense_groups
  resources :employees

  post "create_expense/:id/:expg_id", to: "expenses#create_expense"
  post "create_expense_group/:id", to: "expense_groups#create_expense_group"

  get "show_employees/:id", to: "employees#show_employees"

  get "terminate/:id", to: "employees#terminate"

  get "employee_search/:id/:e_id", to: "employees#search_employee"


  post "create_comment/:id/:emp_id/:expg_id/:exp_id", to: "comments#create_comment"

  post "reply_comment/:id", to: "comments#reply_comment"
  get "show_expenses/:id/:ex_g_id", to: "expenses#show_expenses"

  get "show_comments/:id", to: "comments#show_comments"

  delete "delete_comment/:id/:emp_id/:expg_id/:exp_id/:c_id", to: "comments#delete_comment"
  patch "modify_reply/:id", to: "comments#modify_reply"

  delete "delete_expense/:id/:exp_id", to: "expenses#delete_expense"
  delete "delete_employee/:id/:e_id", to: "employees#delete_employee"

  post "expense_status/:id/:emp_id/:expg_id/:exp_id", to: "expenses#expense_status"

  post "expense_group_status/:id/:emp_id/:expg_id", to: "expense_groups#expense_group_status"


  delete "delete_expense_group/:id", to: "expense_groups#delete_expense_group"
end

