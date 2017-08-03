feature "Invite to sign up" do
  scenario "Successfully invites a friend and invitation is accepted", {vcr: true, js: true} do
    user = Fabricate(:user)
    sign_in(user)

    invite_friend
    sign_out
    
    friend_accpet_invite
    click_link "People"

    expect(page).to have_content(user.full_name)
    sign_out

    sign_in(user)
    click_link "People"
    expect(page).to have_content("Joe Doe")
  end

  def invite_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Joe Doe"
    fill_in "Friend's Email", with: "joe@example.com"
    fill_in "Invitation Message", with: "Hey, please join the site."

    click_button "Send Invitation"
  end

  def friend_accpet_invite
    open_email "joe@example.com"
    current_email.click_link "Accept"
    fill_in "Full Name", with: "Joe Doe"
    fill_in "Password", with: "password"
    fill_in "Credit Card", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "#{Date.today.year + 2}", from: "date_year"    
    click_button "Sign Up"
  end
end