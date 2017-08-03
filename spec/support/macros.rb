def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(a_user=nil)
  visit sign_in_path
  user = a_user || Fabricate(:user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button 'Sign in'
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def stripe_create_token(card_number)
  Stripe::Token.create(
    card: {
      number: card_number,
      exp_month: 6,
      exp_year: Date.today.year + 1,
      cvc: 123
    }
  ).id
end

def stripe_wrapper_response(token)
  StripeWrapper::Charge.create(
    :amount => 999,
    :source => token,
    :description => "stripe charge"
  )
end