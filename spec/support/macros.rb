def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
  session[:user_id]
end