feature "user registers", { vcr: true, js: true } do
  background do
    visit register_path
  end
  
  context "with valid user info" do
    scenario "valid card" do
      fill_in_user("test@example.com")
      fill_in_card("4242424242424242")
      click_button "Sign Up"

      expect(page).to have_content("Welcome to myfix Test user!")
    end
    
    scenario "invalid card" do
      fill_in_user("test@example.com")
      fill_in_card("123")
      click_button "Sign Up"

      expect(page).to have_content("The card number is not a valid credit card number")
    end
    
    scenario "declined card" do
      fill_in_user("test@example.com")
      fill_in_card("4000000000000002")
      click_button "Sign Up"

      expect(page).to have_content("Your card was declined.")
    end
  end

  context "invalid user" do
    scenario "valid card" do
      fill_in_user(nil)
      fill_in_card("4242424242424242")
      click_button "Sign Up"
      
      expect(page).to have_content("Email Address
can't be blank")
      expect(page).to have_content("Invalid user info please check the errors")
    end
    
    scenario "invalid card" do
      fill_in_user(nil)
      fill_in_card("123")
      click_button "Sign Up"

      expect(page).to have_content("The card number is not a valid credit card number")
    end

    scenario "declined card" do
      fill_in_user(nil)
      fill_in_card("4000000000000002")
      click_button "Sign Up"

      expect(page).to have_content("Invalid user info please check the errors")
    end
  end

  def fill_in_user(email)
    fill_in "Email", with: email
    fill_in "Password", with: "12345"
    fill_in "Full Name", with: "Test user"
  end

  def fill_in_card(card)
    fill_in "Credit Card Number", with: card
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "#{Date.today.year + 2}", from: "date_year"
  end
end