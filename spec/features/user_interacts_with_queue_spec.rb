feature "User interacts with the queue" do
  scenario "user adds and reorders videos in the queue" do
    cat = Fabricate(:category)
    video1 = Fabricate(:video, title: "video1", category: cat)
    video2 = Fabricate(:video, title: "video2", category: cat)
    video3 = Fabricate(:video, title: "video3", category: cat)

    sign_in
    find("a[href='/videos/#{video1.id}']").click
    expect(page).to have_content(video1.title)

    click_link "+ My Queue"
    expect(page).to have_content(video1.title)

    visit video_path(video1)
    expect(page).not_to have_content("+ My Queue")

    add_video_to_queue(video2)
    add_video_to_queue(video3)

    update_video_in_queue(video1, 3)
    update_video_in_queue(video2, 1)
    update_video_in_queue(video3, 2)
    
    expect(find(:xpath, "//tr[contains(., '#{video1.title}')]//input[@type='text']").value).to eq("3")
    expect(find(:xpath, "//tr[contains(., '#{video2.title}')]//input[@type='text']").value).to eq("1")
    expect(find(:xpath, "//tr[contains(., '#{video3.title}')]//input[@type='text']").value).to eq("2")        
  end

  def add_video_to_queue(video)
    visit home_path
    click_on_video_on_home_page(video)
    click_link "+ My Queue"
  end

  def update_video_in_queue(video, new_order)
    within(:xpath, "//tr[contains(., '#{video.title}')]") do
      fill_in "queue_items[][list_order]", with: new_order
    end
  end
end