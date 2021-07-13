Rails.application.routes.draw do
  resources :comments
  resources :expenses
  resources :expense_groups
  resources :employees

  post "create_expense", to: "expenses#create_expense"
  post "create_expense_group", to: "expense_groups#create_expense_group"

  get "show_employees", to: "employees#show_employees"

  get "terminate", to: "employees#terminate"

  get "employee_search", to: "employees#search_employee"


  post "create_comment", to: "comments#create_comment"

  post "reply_comment", to: "comments#reply_comment"
  get "show_expenses", to: "expenses#show_expenses"

  delete "delete_comment", to: "comments#delete_comment"
  patch "modify_reply", to: "comments#modify_reply"

  delete "delete_expense", to: "expenses#delete_expense"
  delete "delete_employee", to: "employees#delete_employee"

  post "expense_status", to: "expenses#expense_status"

  post "expense_group_status", to: "expense_groups#expense_group_status"


  delete "delete_expense_group", to: "expense_groups#delete_expense_group"
end

