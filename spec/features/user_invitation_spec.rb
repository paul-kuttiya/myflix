feature "Invite to sign up" do
  scenario "Successfully invites a friend and invitation is accepted" do
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
    click_button "Sign Up"
  end
end