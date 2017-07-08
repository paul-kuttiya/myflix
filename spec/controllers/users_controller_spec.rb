describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns[:user]).to be_instance_of(User)
    end

    it "redirects user if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid users" do
      before do
        post :create, user: {full_name: 'abc', email: 'abc@gg.com', password: '1234'}
      end

      it "saves user" do
        expect(User.count).to eq(1)
      end

      it "stored user in session" do
        expect(session[:user_id]).not_to be_nil
      end

      it "shows notification" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end
  
    context "invalid users" do
      before do
        post :create, user: {email: 'abc@gg.com', password: '1234'}
      end

      it "sets user" do
        expect(assigns[:user]).to be_instance_of(User)
      end

      it "does not create user" do
        expect(User.count).to be(0)
      end

      it "render new template" do
        expect(response).to render_template :new
      end
      
      it "shows error" do
        errors = assigns[:user].errors.full_messages.length
        expect(errors).not_to be(0)
      end
    end
  end

  describe "GET show" do
    describe "non user" do
      it_behaves_like "requires sign in" do
        let(:action) { get :show, id: 1 }
      end
    end

    describe "user" do
      it "sets user" do
        user = Fabricate(:user)
        set_current_user(user)
        get :show, id: user.id
        expect(assigns[:user]).to eq user
      end
    end
  end
end