describe QueueItemsController do
  describe "GET index" do
    it_behaves_like "requires sign in" do
      let(:action) {get :index}
    end

    it "sets @queue_item for user" do
      user_id = set_current_user
      queue_item1 = Fabricate(:queue_item, user_id: user_id, video: Fabricate(:video))
      queue_item2 = Fabricate(:queue_item, user_id: user_id, video: Fabricate(:video))
      get :index

      expect(assigns[:queue_items]).to match_array([queue_item1, queue_item2])
    end
  end

  describe "POST create" do
    describe "non user" do
      it_behaves_like "requires sign in" do
        let(:action) {post :create, video_id: Fabricate(:video).id}
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
        Fabricate(:queue_item, user_id: user.id, video_id: video.id)

        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "flash message for existing queue" do
        Fabricate(:queue_item, user_id: user.id, video_id: video.id)
        post :create, video_id: video.id

        expect(flash[:danger]).to be_present
      end

      it "redirects back to video page for existing queue" do
        Fabricate(:queue_item, user_id: user.id, video_id: video.id)
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
        
        expect(User.find(user).queue_items).to match_array([queue_item2, queue_item1])
      end

      it "redirects to queue page" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end
    end
  end

  describe "DELETE destroy" do
    describe "non user" do
      it_behaves_like "requires sign in" do
        let(:action) {delete :destroy, id: 3}
      end
    end

    describe "signed in user" do
      let(:user) {Fabricate(:user)}
      let(:video) {Fabricate(:video)}

      before do
        session[:user_id] = Fabricate(:user)
      end

      it "find @queue_item" do
        queue_item = Fabricate(:queue_item, user: user, video_id: video.id)
        delete :destroy, id: queue_item.id

        expect(assigns[:queue_item]).to eq(queue_item)
      end

      it "removes queue item" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item = Fabricate(:queue_item, user: alice)
        
        delete :destroy, id: queue_item.id
        expect(QueueItem.all.length).to eq(0)
      end

      it "normalize queue items after remove one" do
        video2 = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: user, video_id: video.id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user: user, video_id: video2.id, list_order: 2)
        delete :destroy, id: queue_item.id

        expect(QueueItem.first.list_order).to eq(1)
      end
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      it "redirects to my queue page" do
        user_id = set_current_user
        queue_item1 = Fabricate(:queue_item, user_id: user_id) 
        queue_item2 = Fabricate(:queue_item, user_id: user_id)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 1}, {id: queue_item2.id, list_order: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        user_id = set_current_user        
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user_id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 2}, {id: queue_item2.id, list_order: 1}]
        expect(User.find(user_id).queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalize the list order" do
        user_id = set_current_user        
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user_id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 2}]
        expect(queue_item1.reload.list_order).to eq(2)
        expect(queue_item2.reload.list_order).to eq(1)
        expect(User.find(user_id).queue_items.map(&:list_order)).to eq([1, 2])
      end
    end

    context "with invalid input" do
      it "redirects to my queue page" do
        user_id = set_current_user                
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user_id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 3.4}]
        expect(response).to redirect_to my_queue_path
      end

      it "flashes message" do
        user_id = set_current_user                
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user_id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 3.4}]
        expect(flash[:danger]).to be_present
      end

      it "does not change queue items" do
        user_id = set_current_user                        
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user_id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 1}, {id: queue_item2.id, list_order: 2.4}]
        expect(queue_item1.reload.list_order).to eq(1)
        expect(queue_item2.reload.list_order).to eq(2)
      end
    end

    context "not a user" do
      it_behaves_like "requires sign in" do
        let(:action) {post :update_queue, queue_items: []}
      end
    end

    context "with queue items that does not belongs to user" do
      it "does not change the queue items" do
        user_id = set_current_user                                
        user2 = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user_id: user_id, list_order: 1)
        queue_item2 = Fabricate(:queue_item, user_id: user2.id, list_order: 2)

        post :update_queue, queue_items: [{id: queue_item1.id, list_order: 3}, {id: queue_item2.id, list_order: 2}]
        expect(queue_item1.reload.list_order).to eq(1)
      end
    end
  end
end