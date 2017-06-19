describe QueueItemsController do
  describe "GET index" do
    it "returns to sign in page for non users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end

    it "sets @queue_item for user" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item1 = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      queue_item2 = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      get :index

      expect(assigns[:queue_items]).to match_array([queue_item1, queue_item2])
    end
  end

  describe "POST create" do
    it "redirects to sign in page if not user" do
      post :create, video_id: Fabricate(:video).id

      expect(response).to redirect_to sign_in_path
    end

    it "create queue_item for user" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video_id: video.id)
      expect(QueueItem.first).to eq(queue_item)
    end
  end
end