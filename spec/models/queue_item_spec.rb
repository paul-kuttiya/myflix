describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "should return title for video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#ratings" do
    it "should return ratings when review is presented" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, ratings: 4)

      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.ratings).to eq(4)
    end

    it "returns nil when user not yet to review" do
      video = Fabricate(:video)
      user = Fabricate(:user)

      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.ratings).to be_nil
    end
  end

  describe "#category_name" do
    it "returns category name" do
      category = Fabricate(:category, name: "action")
      video = Fabricate(:video, category: category)
      user = Fabricate(:user)

      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category_name).to eq("action")
    end
  end
end