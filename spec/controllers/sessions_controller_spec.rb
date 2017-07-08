describe SessionsController do
  describe "GET new" do
    it "renders new template for unautherized user" do
      get :new
      expect(response).to render_template(:new)
    end
    
    it "redirect to home page for authrorized user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid credentials" do
      let(:user) {Fabricate(:user)}
      before do
        post :create, email: user.email, password: user.password
      end
      
      it "stores user session" do
        expect(session[:user_id]).to be(user.id)
      end

      it "flash success message" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "invalid credential" do
      let(:user) {Fabricate(:user)}
      before do
        post :create, email: user.email, password: user.password + 'abcd'
      end

      it "does not store session" do
        expect(session[:user_id]).to be_nil
      end

      it "flash danger message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "GET destroy" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :destroy
      end

      it "destroys user sessions" do
        expect(session[:user_id]).to be_nil
      end

      it "shows sign out message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to root" do
        expect(response).to redirect_to root_path
      end
    end
  end
end