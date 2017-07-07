feature 'User following' do
  scenario "user follows and unfollows someone" do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: alice, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link "by #{alice.full_name}"
    click_link "Follow"
    expect(page).to have_content(alice.full_name)

    unfollows(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollows(user)
    find("a[data-method='delete']").click
  end
end