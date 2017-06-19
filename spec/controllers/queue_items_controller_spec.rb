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
    describe "non user" do
      it "redirects to sign in page if not user" do
        post :create, video_id: Fabricate(:video).id

        expect(response).to redirect_to sign_in_path
      end
    end

    describe "signed in user" do
      let(:user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}

      before do
        session[:user_id] = user.id
      end

      it "create queue_item for user" do
        post :create, video_id: video.id
        expect(assigns[:queue_item]).to be_instance_of(QueueItem)
      end

      it "create queue_item that has video for user" do
        post :create, video_id: video.id
        expect(assigns[:queue_item].video).to eq(video)
      end

      it "won't add video if already exists in queue" do
        QueueItem.create(user: user, video_id: video.id)
        post :create, video_id: video.id

        expect(QueueItem.count).to eq(1)
      end

      it "flash message for existing queue" do
        QueueItem.create(user: user, video_id: video.id)
        post :create, video_id: video.id

        expect(flash[:danger]).not_to be_blank
      end

      it "redirects back to video page for existing queue" do
        QueueItem.create(user: user, video_id: video.id)
        post :create, video_id: video.id

        expect(response).to redirect_to video_path(video)
      end

      it "added queue gets appended to new queue for user" do
        queue_item = Fabricate(:queue_item, user: user, video_id: video.id)

        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(user)
      end

      it "has queue for signed in uesr" do
        video2 = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: user, video_id: video.id)
        queue_item2 = Fabricate(:queue_item, user: user, video_id: video2.id)

        post :create, video_id: video.id
        post :create, video_id: video2.id
        
        expect(User.find(user).queue_items).to match_array([queue_item1, queue_item2])
      end

      it "redirects to queue page" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end
end