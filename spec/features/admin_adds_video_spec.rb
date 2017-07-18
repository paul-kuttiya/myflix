feature "admin adds new video" do
  scenario "admin successfully adds a new video" do
    admin = Fabricate(:admin)
    category = Fabricate(:category, name: "action")
    sign_in(admin)

    visit new_admin_video_path
    fill_in "Title", with: "new video"
    select "action", from: "Category"
    fill_in "Description", with: "video description"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    fill_in "Video url", with: "http://www.example.com"
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com']")    
  end
end