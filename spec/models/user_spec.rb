describe User do
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:password)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of(:email)}
  it {should have_many(:queue_items).order(list_order: :asc)}

  describe "#already_queued?" do
    it "returns true when user already has video in queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(user.already_queued?(video)).to eq(true)
    end

    it "returns false when user not yet add video in queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user)

      expect(user.already_queued?(video)).to eq(false)
    end
  end
end

