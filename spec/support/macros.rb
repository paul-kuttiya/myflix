def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
  session[:user_id]
end

def sign_in(a_user=nil)
  visit sign_in_path
  user = a_user || Fabricate(:user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button 'Sign in'
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end