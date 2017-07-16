describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets new @video" do
      set_current_admin
      get :new
      expect(assigns[:video]).to be_new_record
      expect(assigns[:video]).to be_instance_of Video
    end

    it "flashes error message for non admin user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end

    it "redirect regular user to root path" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, video: Fabricate(:video) }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create, video: Fabricate(:video) }
    end
    
    context "valid inputs" do
      let(:video) { Fabricate.attributes_for(:video) }

      before do
        set_current_admin
        post :create, { video: video }
      end
      
      it "redirects to video new page" do
        expect(response).to redirect_to new_admin_video_path
      end
      
      it "creates new @video" do
        expect(Video.count).to eq 1
      end
        
      it "flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "invalid inputs" do
      let(:video) { Fabricate.attributes_for(:video, title: nil) }

      before do
        set_current_admin
        post :create, { video: video }
      end

      it "does not save video" do
        expect(Video.count).to eq 0
      end
      
      it "renders new template" do
        expect(response).to render_template :new
      end
      
      it "has errors message array" do
        errors_arr = assigns[:video].errors.full_messages
        expect(errors_arr.length).to eq 1
      end
    end
  end
end